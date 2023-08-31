//
//  Router.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import UIKit
import Tracker

/**
 * Utility class used to manage transitions between controllers
 */
public class Router {
    
    public static let instance = Router()
    
    fileprivate var controllerTransition = ControllerTransition.DEFAULT
    
    fileprivate func startController(_ presenter: BaseController, _ presented: BaseController, _ boundle: Boundle? = nil) {
        if boundle != nil {
            presented.controllerBoundle = boundle!
        }
        presenter.controllerTransition = controllerTransition
        presenter.navigationController?.delegate = presenter
        presenter.navigationController?.pushViewController(presented, animated: true)
        reset()
    }
    
    fileprivate func startControllerForResult(_ presenter: BaseController, _ presented: BaseController, _ boundle: Boundle, _ requestCode: Int) {
        if requestCode == Constants.INVALID {
            Exception("Missing request code for controller result")
        }
        presented.requestCode = requestCode
        presented.resultListener = presenter
        startController(presenter, presented, boundle)
    }
    
    public func startBaseController(_ presenter: BaseController, _ provider: ControllerProvider, _ boundle: Boundle? = nil) {
        startController(presenter, provider.getController(), boundle)
    }
    
    public func startBaseControllerForResult(_ presenter: BaseController, _ provider: ControllerProvider, _ boundle: Boundle, _ requestCode: Int = Constants.INVALID) {
        startControllerForResult(presenter, provider.getController(), boundle, requestCode)
    }
    
    public func backToController(_ presenter: BaseController, _ provider: ControllerProvider) -> Bool {
        let controllerInStack = (presenter.navigationController as? BaseNavigationController)?.viewControllerOfType(provider.getController().classForCoder)
        if controllerInStack != nil {
            controllerInStack!.controllerTransition = controllerTransition
            controllerInStack!.navigationController?.delegate = controllerInStack
            return (presenter.navigationController as? BaseNavigationController)!.popToViewControllerOfType(provider.getController().classForCoder)
        }
        return false
    }
    
    public func startWebView(_ presenter: BaseController, _ url: String, _ title: String) {
        let boundle = Boundle()
        boundle.putString(Extra.WEBVIEW_URL.key, url)
        boundle.putString(Extra.WEBVIEW_TITLE.key, title)
        startBaseController(presenter, Controllers.WEBVIEW, boundle)
    }
    
    public func startWebViewForResult(_ presenter: BaseController, _ url: String, _ title: String, _ requestCode: Int = Constants.INVALID) {
        let boundle = Boundle()
        boundle.putString(Extra.WEBVIEW_URL.key, url)
        boundle.putString(Extra.WEBVIEW_TITLE.key, title)
        startControllerForResult(presenter, Controllers.WEBVIEW.getController(), boundle, requestCode)
    }
    
    public func openSettings() {
        let url = UIApplication.openSettingsURLString
        openUrl(url)
    }
    
    public func openPrivacy() {
        let url = StringProvider.get("privacy_policy_link_en")
        openUrl(url)
    }
    
    public func openUrl(_ urlString: String) {
        let url = URL(string: urlString)
        if url != nil {
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.open(url!, completionHandler: { success in
                    if !success {
                        Logger.e("Error trying to open url \(url!)")
                    }
                })
            } else {
                Logger.e("Unable to open url \(url!)")
            }
        } else {
            Logger.e("Url is null on opening")
        }
    }
    
    public func showAppOnStore(appId: String) {
        var appStoreUrl = "itms://itunes.apple.com/us/app/apple-store/id\(appId)?mt=8"
        var url = URL(string: appStoreUrl)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            appStoreUrl = "https://itunes.apple.com/app/id\(appId)"
            url = URL(string: appStoreUrl)!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                Logger.e("Unable to open app page on store and on browser")
            }
        }
    }
    
    @discardableResult
    public func controllerTransition(_ value: ControllerTransition) -> Router {
        controllerTransition = value
        return self
    }
    
    fileprivate func reset() {
        controllerTransition = .DEFAULT
    }
    
    public func homepage(_ presenter: BaseController, back: Bool = false) {
        if Preferences.user.isUserRegistered() {
            controllerTransition(.FADE)
            if !back || !Router.instance.backToController(presenter, Controllers.PATIENT) {
                startBaseController(presenter, Controllers.PATIENT)
            }
        }
    }
    
    public func logout(_ presenter: BaseController) {
        BasePreferences.logout()
        Database.instance.logout()
        startBaseController(presenter, Controllers.SPLASH)
        TrackerManager.instance.stopLocationTracking()
        TrackerManager.instance.logout()
    }
}
