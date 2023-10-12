//
//  TrackerController.swift
//  App
//
//  Created by Omar Brugna on 28/07/2023.
//

import UIKit
import Tracker

open class TrackerController : BaseController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        enableBroadcast()
    }
    
    func doResume() -> Bool {
        let hasMotionAuthorization = TrackerManager.instance.hasMotionAuthorization()
        if hasMotionAuthorization {
            
            if Preferences.lifecycle.firstComputation == nil && Preferences.user.isUserRegistered() {
                // remember first computation date
                Preferences.lifecycle.firstComputation = TimeUtils.getCurrent()
            }
            
            refresh()
            return true
        } else {
            TrackerManager.instance.requestMotionAuthorization({ success in
                if success {
                    let _ = self.doResume()
                } else {
                    //we do need to manage here if the accepts the permission because it will go to ViewWillAppear when returning from Setting
                    self.onPermissionAccessMotionDisabled(Permissions.Group.ACCESS_MOTION)
                    self.hideProgressView()
                }
            })
            return false
        }
    }
    
    fileprivate func refresh() {
        ActivityManager.startAnalyse(self)
    }
    
    public func onRefreshed(_ fromDate: Date, _ toDate: Date) {
        let segments = TrackerTableSegments.getBetween(fromDate, toDate)
        for segment in segments {
            segment.addSteps()
            segment.addBrisk()
            segment.addLocations()
        }
        
        self.onTrajectoriesUpdated(segments)
        
        let dayTotal = DayTotal(fromDate, segments)
        Singleton.onUpdate(self, dayTotal)
    }
    
    fileprivate func enableBroadcast() {
        let broadcast = BaseBroadcast(self)
        broadcast.registerForType(BaseBroadcast.TRACKER_DATA_UPDATED)
        broadcast.setListener({ type, sentByMyself, identifier, subIdentifier in
            switch type {
                case BaseBroadcast.TRACKER_DATA_UPDATED:
                    let fromDate = TimeUtils.parse(identifier, Constants.DATE_FORMAT_ID, convertToDefault: false)
                    let toDate = TimeUtils.parse(subIdentifier, Constants.DATE_FORMAT_ID, convertToDefault: false)
                    if fromDate != nil && toDate != nil {
                        self.onRefreshed(fromDate!, toDate!)
                        let fromDateString = TimeUtils.format(fromDate!, Constants.DATE_FORMAT_UTC, convertToDefault: false)
                        let toDateString = TimeUtils.format(toDate!, Constants.DATE_FORMAT_UTC, convertToDefault: false)
                        Logger.d("Data refreshed from \(fromDateString) to \(toDateString) \(subIdentifier)")
                    } else {
                        Logger.e("From date or to date is null on refreshed \(identifier) - \(subIdentifier)")
                    }
                default:
                    break
            }
        })
    }
    
    open func onTrajectoriesUpdated(_ trajectories: [TrackerDBSegment]) {
        // override to customise
    }
    
    func onPermissionAccessMotionDisabled(_ permissionGroup: Permissions.Group) {
        mainThread {
            let dialog = PermissionsDialog()
            dialog.setCancelable(false)
            dialog.setup(self,Permissions.Group.ACCESS_MOTION.requestCode)
            dialog.setCancelListener {
                Router.instance.openSettings()
            }
            dialog.setPermissionListener {
                Router.instance.openSettings()                
            }
            dialog.show()
        }
    }
}

