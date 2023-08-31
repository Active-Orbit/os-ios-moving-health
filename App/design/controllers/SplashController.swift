//
//  SplashController.swift
//  BaseApp
//
//  Created by Omar Brugna on 09/06/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import UIKit
import Tracker

class SplashController: BaseController {

    @IBOutlet weak var appNameLabel: BaseLabel!
    
    fileprivate var permissionsDialogShown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar()
        
        appNameLabel.text = Environment.APP_NAME
        
        ConsentFormManager.retrieveConsentForm(self)
        
        #if DEBUG
            printInformationLogs()
        #endif
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Utils.delay(TimeUtils.ONE_SECOND_MILLIS, runnable: {
            if !self.permissionsDialogShown {
                self.proceed()
            }
        })
    }
    
    fileprivate func proceed() {
        if Preferences.user.isUserRegistered() {
            if !onboarded() {
                TrackerManager.instance.requestMotionAuthorization({ success in
                    if success {
                        self.proceed()
                    } else {
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
                })
            } else {
                Router.instance
                    .controllerTransition(.FADE)
                    .homepage(self)
            }
        } else {
            Router.instance
                .controllerTransition(.FADE)
                .startBaseController(self, Controllers.WELCOME)
        }
    }
    
    fileprivate func printInformationLogs() {
        
        let appName = Utils.getAppName() ?? Constants.EMPTY
        let appBundleId = Utils.getPackageName() ?? Constants.EMPTY
        let appVersionName = Utils.getVersionName() ?? Constants.EMPTY
        let appVersionCode = Utils.getVersionCode() ?? Constants.EMPTY
        
        let bundlePath = mainBundle.bundlePath
        let bundleUrl = mainBundle.bundleURL.absoluteString
        
        Logger.i("------------------------------------------")
        Logger.i("App name             -> " + appName)
        Logger.i("App bundle id        -> " + appBundleId)
        Logger.i("App bundlePath       -> " + bundlePath)
        Logger.i("App bundleUrl        -> " + bundleUrl)
        Logger.i("App version name     -> " + appVersionName)
        Logger.i("App version code     -> " + appVersionCode)
        Logger.i("------------------------------------------")
        
        BasePreferences.printAll()
    }
}

