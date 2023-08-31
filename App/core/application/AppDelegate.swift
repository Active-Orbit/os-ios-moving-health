//
//  AppDelegate.swift
//  BaseApp
//
//  Created by Omar Brugna on 09/06/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import Tracker

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // this is agreed by default in this project
        TrackerPreferences.options.uploadDataAgreed = true
        
        configureTracker()
        TrackerManager.initialize(launchOptions: launchOptions)
        
        if Preferences.lifecycle.firstInstall == nil {
            // remember first installation date
            Preferences.lifecycle.firstInstall = TimeUtils.getCurrent()
        }
        
        // set app url
        Preferences.backend.baseUrl = Environment.BASE_URL
        
        FirebaseApp.configure()
        FontProvider.load()
        
        GMSServices.provideAPIKey(Environment.GOOGLE_API_KEY)
        
        if !Utils.isSimulator() {
            // register remote notifications delegate
            UNUserNotificationCenter.current().delegate = self
            Messaging.messaging().delegate = self
        }
        
        let controller = Controllers.SPLASH.getController()
        let navigationController = BaseNavigationController(rootViewController: controller)
        navigationController.setToolbarAttributes(
            toolbarBackground: ColorProvider.get("toolbarColorBackground"),
            titleColor: ColorProvider.get("toolbarColorText"),
            titleFont: UIFont(name: FontProvider.REGULAR.name, size: TextSizeProvider.H0.size)!
        )
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = navigationController
        window!.makeKeyAndVisible()
        
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        resetBadgeCount(application)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        let now = TimeUtils.getCurrent()
        if PatientController.lastComputation != nil && (now.timeInMillis - PatientController.lastComputation!.timeInMillis) >= Double(TimeUtils.ONE_MINUTE_MILLIS * 1) {
            for subWindow in application.windows {
                if subWindow.tag == AbstractDialog.TAG_DIALOG {
                    // close the dialogs instances if they are visible
                    subWindow.isHidden = true
                    subWindow.resignKey()
                }
            }
            LifecycleHandler.currentController?.navigationController?.popToRootViewController(animated: false)
        } else {
            LifecycleHandler.isApplicationInForeground = true
            resetBadgeCount(application)
        }
    }
    
    public func applicationWillResignActive(_ application: UIApplication) {
        LifecycleHandler.isApplicationInForeground = false
    }
    
    public func configureTracker() {
        // tracker configurations
        TrackerManager.instance.setTargetApp(.MOVING_HEALTH)
        
        let config = TrackerConfig()
        config.logLevel = .LOW
        config.minimumSegmentDuration = 120
        config.stepsPerSecondThreshold = 0.2
        config.stepsPerBriskMinuteThreshold = 96
        config.locationTrackingEnabled = true
        config.intensityEnabled = true
        config.stepsEnabled = true
        config.cyclingEnabled = true
        config.automotiveEnabled = true
        config.wifyAnalysisEnabled = true
        config.dataUploadEnabled = true
        config.useLegacyDataUpload = false
        config.userRegistrationEnabled = false
        config.useLegacyUserRegistration = false
        TrackerManager.config = config
    }
}

extension AppDelegate {
    
    public func registerForRemoteNotifications(_ application: UIApplication) {
        
        if !Utils.isSimulator() {
            // register for remote notifications
            let authOptions : UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { (granted, error) in
                if granted {
                    mainThread {
                        application.registerForRemoteNotifications()
                    }
                }
            })
        }
    }
    
    public func resetBadgeCount(_ application: UIApplication) {
        if !Utils.isSimulator() {
            // reset badge count
            application.applicationIconBadgeNumber = 0
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Logger.d("Registered for remote notification with token \(deviceToken)")
    }
    
    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Logger.w("Registration for remote notification failed with error: \(error.localizedDescription)")
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        Logger.d("userNotificationCenter willPresent")
        completionHandler([.alert, .badge, .sound])
    }
}

extension AppDelegate: MessagingDelegate {
    
    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if !TextUtils.isEmpty(fcmToken) {
            Logger.d("Refreshed token: \(fcmToken!)")
            Preferences.user.pushToken = fcmToken
        } else {
            Logger.d("Refreshed token is null or empty")
        }
    }
}

