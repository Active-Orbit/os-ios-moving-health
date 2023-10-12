//
//  OnboardingLocationController.swift
//  BaseApp
//
//  Created by Omar Brugna on 16/08/2023.
//

import UIKit
import CBPinEntryView
import Tracker
import WebKit

class OnboardingLocationController: BaseController {
    
    @IBOutlet var toolbar: Toolbar!
    @IBOutlet var mainView: BaseView!
    @IBOutlet var topContainer: UIView!
    @IBOutlet var middleContainer: UIView!
    @IBOutlet var bottomContainer: UIView!
    @IBOutlet var descriptionTop: BaseLabel!
    @IBOutlet var descriptionPhysical: BaseLabel!
    @IBOutlet var descriptionLocation: BaseLabel!
    @IBOutlet var physicalActivityCheckBoxContainer: BaseView!
    @IBOutlet var locationCheckBoxContainer: BaseView!
    @IBOutlet var physicalActivityCheckBox: BaseCheckBox!
    @IBOutlet var locationCheckBox: BaseCheckBox!
    @IBOutlet var stepOne: UIView!
    @IBOutlet var stepTwo: UIView!
    @IBOutlet var stepThree: UIView!
    @IBOutlet var stepFour: UIView!
    @IBOutlet var backBtn: BaseButton!
    @IBOutlet var confirmBtn: BaseButton!
    @IBOutlet var scrollView: BaseScrollView!
    @IBOutlet var stepsLayout: UIView!
    @IBOutlet var buttonsLayout: UIView!
    
    fileprivate var userConsentName = Constants.EMPTY
    fileprivate var userConsentDate = Double(Constants.INVALID)
    
    fileprivate var fromMenu = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar()
        
        toolbar.setup(self)
        toolbar.showBackButton()
        
        fromMenu = controllerBoundle.getBoolean(Extra.FROM_MENU.key)
        
        if !fromMenu {
            userConsentName = controllerBoundle.getString(Extra.USER_CONSENT_NAME.key)!
            userConsentDate = controllerBoundle.getDouble(Extra.USER_CONSENT_DATE.key)
        }
        
        prepare()
        updateCheckBoxes()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCheckBoxes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: UIApplication.willEnterForegroundNotification.rawValue), object: nil)
    }
    
    fileprivate func prepare() {
                
        topContainer.cornerRadius = 10
        middleContainer.cornerRadius = 10
        bottomContainer.cornerRadius = 10
        
        
        physicalActivityCheckBoxContainer.setOnClickListener {
            self.managePhysicalActivity()
        }
        
        
        physicalActivityCheckBox.setOnClickListener {
            self.managePhysicalActivity()
        }
        
        locationCheckBoxContainer.setOnClickListener {
            self.manageLocation()
        }
        
        locationCheckBox.setOnClickListener {
            self.manageLocation()
        }
        
        stepOne.cornerRadius = 5
        stepTwo.cornerRadius = 5
        stepThree.cornerRadius = 5
        stepFour.cornerRadius = 5

        
        descriptionTop.attributedText = StringProvider.get("onboarding_location_0").htmlToAttributedString(size: TextSizeProvider.H5.size, color: ColorProvider.get("textColorPrimaryDark")!, font: FontProvider.getFontName(index: 0),allignment: Constants.ALIGN_TEXT_LEFT)
        
        descriptionPhysical.attributedText = StringProvider.get("onboarding_location_1").htmlToAttributedString(size: TextSizeProvider.H5.size, color: ColorProvider.get("textColorPrimaryDark")!, font: FontProvider.getFontName(index: 0),allignment: Constants.ALIGN_TEXT_LEFT)
        
        descriptionLocation.attributedText = StringProvider.get("onboarding_location_2").htmlToAttributedString(size: TextSizeProvider.H5.size, color: ColorProvider.get("textColorPrimaryDark")!, font: FontProvider.getFontName(index: 0),allignment: Constants.ALIGN_TEXT_LEFT)
        
        
        if fromMenu {
            stepsLayout.visibility = .gone
            buttonsLayout.visibility = .gone
            physicalActivityCheckBox.isUserInteractionEnabled = false
        } else {
            physicalActivityCheckBox.isUserInteractionEnabled = true
            backBtn.setOnClickListener {
                self.finish()
            }
        }
        
        confirmBtn.setOnClickListener {
            if TrackerManager.instance.hasMotionAuthorization() {
                let boundle = Boundle()
                boundle.putString(Extra.USER_CONSENT_NAME.key, self.userConsentName)
                boundle.putDouble(Extra.USER_CONSENT_DATE.key, self.userConsentDate)
                Router.instance
                    .controllerTransition(ControllerTransition.LEFT_TO_RIGHT)
                    .startBaseController(self, Controllers.PATIENT_DETAILS, boundle)
            } else {
                Toast.showLongToast(self.view, StringProvider.get("activity_rec_permissions_not_granted"))
                self.scrollView.scrollToView(self.middleContainer, true)
            }
        }
    }
    
    
    fileprivate func managePhysicalActivity() {
        if !TrackerManager.instance.hasMotionAuthorization() {
            TrackerManager.instance.requestMotionAuthorization({ success in
                if success {
                    self.updateCheckBoxes()
                } else {
                    // we do need to manage here if the accepts the permission because it will go to ViewWillAppear when returning from Setting
                    let dialog = PermissionsDialog()
                    dialog.setCancelable(false)
                    dialog.setup(self,Permissions.Group.ACCESS_MOTION.requestCode)
                    dialog.setPermissionListener {
                        Router.instance.openSettings()
                    }
                    dialog.show()
                }
            })
        } else {
            Toast.showLongToast(self.view, "This permission is needed to join the study, otherwise you will not be able to continue.")
        }
    }
    
    fileprivate func manageLocation() {
        if !TrackerManager.instance.hasLocationAuthorizationWhenInUse() {
            TrackerManager.instance.requestLocationAuthorizationWhenInUse({ success in
                if success {
                    self.updateCheckBoxes()
                    TrackerManager.instance.requestLocationAuthorizationAlways({ success in
                        if success {
                            self.updateCheckBoxes()
                        } else {
                            // we do need to manage here if the accepts the permission because it will go to ViewWillAppear when returning from Setting
                            let dialog = PermissionsDialog()
                            dialog.setCancelable(false)
                            dialog.setup(self,Permissions.Group.ACCESS_LOCATION_ALWAYS.requestCode)
                            dialog.setPermissionListener {
                                Router.instance.openSettings()
                            }
                            dialog.show()
                        }
                    })
                } else {
                    // we do need to manage here if the accepts the permission because it will go to ViewWillAppear when returning from Setting
                    let dialog = PermissionsDialog()
                    dialog.setCancelable(false)
                    dialog.setup(self,Permissions.Group.ACCESS_LOCATION_WHEN_IN_USE.requestCode)
                    dialog.setPermissionListener {
                        Router.instance.openSettings()
                    }
                    dialog.show()
                }
            })
        } else if !TrackerManager.instance.hasLocationAuthorizationAlways() {
            TrackerManager.instance.requestLocationAuthorizationAlways({ success in
                if success {
                    self.updateCheckBoxes()
                } else {
                    // we do need to manage here if the accepts the permission because it will go to ViewWillAppear when returning from Setting
                    let dialog = PermissionsDialog()
                    dialog.setCancelable(false)
                    dialog.setup(self,Permissions.Group.ACCESS_LOCATION_ALWAYS.requestCode)
                    dialog.setPermissionListener {
                        Router.instance.openSettings()
                    }
                    dialog.show()
                }
            })
        } else {
            Router.instance.openSettings()
        }
    }
    
    fileprivate func updateCheckBoxes() {
        physicalActivityCheckBox.isChecked = TrackerManager.instance.hasMotionAuthorization()
        locationCheckBox.isChecked = TrackerManager.instance.hasLocationAuthorizationWhenInUse()
    }
    
    @objc func willEnterForeground() {
        updateCheckBoxes()
    }
    
    
}
