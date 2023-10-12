//
//  PatientController.swift
//  BaseApp
//
//  Created by Omar Brugna on 23/06/2023.
//

import UIKit
import Tracker

class PatientController: TrackerController {
    
    @IBOutlet var toolbar: Toolbar!
    @IBOutlet var activityPanel: ActivityPanelComponent!
    @IBOutlet var mobilityPanel: MobilityPanelComponent!
    @IBOutlet var bottomNavigation: BottomNavigationComponent!
    
    fileprivate var isUpdating = false
    public static var lastComputation: Date? = nil
    
    fileprivate var debugCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar()
        
        toolbar.setup(self)
        toolbar.setTitle(Environment.APP_NAME)
        toolbar.showMenuComponent()
        
        prepare()
        
        enableBroadcast()
        
        Singleton.currentDateTime = TimeUtils.startOfDay()
        
        TrackerManager.instance.startLocationTracking()
        
        // TODO remove on release
        debugView()
    }
    
    fileprivate func prepare() {
        
        activityPanel.setProgress(0, 0, 0, 0, 0, 0, 0)
        mobilityPanel.setProgress(0, 0, 0)
        
        activityPanel.setOnClickListener {
            // TODO
        }
        
        mobilityPanel.setOnClickListener {
            // TODO
        }
        
        bottomNavigation.setSelected(BottomNavItemType.MAIN, self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Preferences.user.isUserRegistered() {
            let _ = resume()
        } else {
            Logger.e("User is not logged in \(className) on resume, force logout")
            Router.instance.logout(self)
            finish()
        }
    }
    
    public func resume() -> Bool {
        var shouldUpdate = false
        let now = TimeUtils.getCurrent()
        
        if PatientController.lastComputation == nil {
            shouldUpdate = true
        } else {
            let lastComputationDay = Calendar.current.ordinality(of: .day, in: .year, for: PatientController.lastComputation!)
            let todayComputationDay = Calendar.current.ordinality(of: .day, in: .year, for: now)
            if lastComputationDay != todayComputationDay {
                Logger.d("Forcing data computation because of new day")
                Singleton.currentDateTime = TimeUtils.startOfDay()
                shouldUpdate = true
            }
            
            if (now.timeInMillis - PatientController.lastComputation!.timeInMillis) >= Double(TimeUtils.ONE_MINUTE_MILLIS) {
                shouldUpdate = true
            }
        }
        
        if shouldUpdate {
            
            let hasMotionAuthorization = TrackerManager.instance.hasMotionAuthorization()
            if hasMotionAuthorization {
                // allow the refresh until the permission is granted
                PatientController.lastComputation = now
            } else {
                return doResume()
            }
            
            let lastAnalysed = TableAnalyse.getAll().first
            if lastAnalysed != nil {
                let lastAnalysedCalendar = lastAnalysed!.getCalendar()
                var yesterdayCalendar = TimeUtils.startOfDay(Singleton.currentDateTime)
                yesterdayCalendar = yesterdayCalendar.add(component: .day, value: -1)!
                
                let lastComputationDay = Calendar.current.ordinality(of: .day, in: .year, for: PatientController.lastComputation!)
                let todayComputationDay = Calendar.current.ordinality(of: .day, in: .year, for: now)
                
                if lastAnalysedCalendar.before(yesterdayCalendar) || lastComputationDay != todayComputationDay {
                    return doResume()
                } else {
                    showProgressView(autoHide: true)
                    return doResume()
                }
            } else {
                showProgressView(autoHide: true)
                return doResume()
            }
        } else {
            Logger.d("Skipping data computation, too early")
            return false
        }
    }
    
    override func onTrajectoriesUpdated(_ trajectories: [TrackerDBSegment]) {
        // TODO
    }
    
    fileprivate func enableBroadcast() {
        let broadcast = BaseBroadcast(self)
        broadcast.registerForType(BaseBroadcast.ACTIVITIES_LOADING)
        broadcast.registerForType(BaseBroadcast.ACTIVITIES_UPDATED)
        broadcast.registerForType(BaseBroadcast.APPLICATION_FOREGROUND)
        broadcast.setListener({ type, sentByMyself, identifier, subIdentifier in
            switch type {
                case BaseBroadcast.ACTIVITIES_LOADING:
                    self.onActivitiesLoading(identifier)
                case BaseBroadcast.ACTIVITIES_UPDATED:
                    self.onActivitiesUpdated()
                case BaseBroadcast.APPLICATION_FOREGROUND:
                    if LifecycleHandler.currentController is PatientController {
                        Singleton.currentDateTime = TimeUtils.startOfDay()
                        let _ = self.resume()
                    }
                default:
                    break
            }
        })
    }
    
    fileprivate func onActivitiesLoading(_ message: String) {
        mainThread {
            self.showProgressView(autoHide: true)
        }
    }
    
    fileprivate func onActivitiesUpdated() {
        hideProgressView()
        if !isUpdating {
            isUpdating = true
            
            var minutesWalking = 0
            var distanceWalking = Double(0)
            var minutesHeart = 0
            var distanceHeart = Double(0)
            var minutesCycling = 0
            var distanceCycling = Double(0)
            var minutesVehicle = 0
            var distanceVehicle = Double(0)
            var vehicleTrips = 0
            var steps = 0
            
            Utils.delay(300, runnable: { [self] in
                let model = Singleton.dayTotalToday
                if model != nil {
                    minutesWalking = Int(model!.timeWalking / 60)
                    distanceWalking = model!.totalDistanceWalked / 1000
                    minutesHeart = Int(model!.timeBriskWalking / 60)
                    distanceHeart = model!.totalDistanceRunned / 1000
                    minutesCycling = Int(model!.timeCycling / 60)
                    distanceCycling = model!.totalDistanceCycled / 1000
                    minutesVehicle = Int(model!.timeInVehicle / 60)
                    distanceVehicle = model!.totalDistanceDriven / 1000
                    vehicleTrips = model!.trajectories.filter({ $0.type == TrackerActivityType.AUTOMOTIVE.id }).count
                    steps = model!.numberOfSteps
                } else {
                    Logger.e("Daily model is null on \(className)")
                }
                
                activityPanel.setProgress(minutesWalking, minutesHeart, minutesCycling, distanceWalking, distanceHeart, distanceCycling, steps)
                mobilityPanel.setProgress(vehicleTrips, distanceVehicle, minutesVehicle)
                
                isUpdating = false
            })
        }
    }
    
    fileprivate func debugView() {
        activityPanel.setOnClickListener {
            self.debugCounter += 1
            if self.debugCounter == 5 {
                self.debugCounter = 0
                Router.instance.startBaseController(self, Controllers.SEGMENTS)
            }
        }
    }
}

