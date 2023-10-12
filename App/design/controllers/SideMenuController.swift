//
//  SideMenuController.swift
//  App
//
//  Created by George Stavrou on 04/04/2023.
//

import UIKit

class SideMenuController: BaseController {
    
    @IBOutlet var backgroundView: BaseView!
    @IBOutlet weak var closeSideMenuContainer: BaseView!
    @IBOutlet weak var closeSideMenu: BaseImageView!
    @IBOutlet weak var userNhsNumber: BaseLabel!
    @IBOutlet weak var userNhsNumberHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuHome: SideMenuComponent!
    @IBOutlet weak var menuSettings: SideMenuComponent!
    @IBOutlet weak var menuHelp: SideMenuComponent!
    @IBOutlet weak var menuConsent: SideMenuComponent!
    @IBOutlet weak var menuFinish: SideMenuComponent!
    
    fileprivate var gradient: CAGradientLayer?
    
    var presenter: BaseController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
        setUserDetails()
        setClickListeners()
        setUserDetails()
    }
    
    fileprivate func prepare() {
        closeSideMenuContainer.rounded()
        closeSideMenuContainer.showShadow()
        
        menuHome.setup(ImageProvider.get("ic_menu_home"), StringProvider.get("home"))
        menuSettings.setup(ImageProvider.get("ic_menu_settings"), StringProvider.get("settings"))
        menuHelp.setup(ImageProvider.get("ic_menu_help"), StringProvider.get("help"))
        menuConsent.setup(ImageProvider.get("ic_menu_consent"), StringProvider.get("consent_form"))
        menuFinish.setup(ImageProvider.get("ic_menu_dismiss_patient"), StringProvider.get("dismiss_patient"))
    }
    
    fileprivate func setUserDetails() {
        if Preferences.user.isUserRegistered() {
            userNhsNumberHeightConstraint.constant = 30
            userNhsNumber.visibility = .visible
            userNhsNumber.text = String(format: StringProvider.get("patient_id_value"), Preferences.user.userNhsNumber ?? Constants.EMPTY)
            menuFinish.visibility = .visible
            menuConsent.visibility = .visible

        } else {
            userNhsNumber.clear()
            userNhsNumber.visibility = .invisible
            userNhsNumberHeightConstraint.constant = 0
            menuFinish.visibility = .visible
            menuConsent.visibility = .visible
        }
    }
    
    fileprivate func setClickListeners() {
        closeSideMenuContainer.setOnClickListener {
            self.dismiss(animated: true)
        }
        
        menuHome.setOnClickListener {
            self.dismiss(animated: true, completion: {
                if self.presenter != nil {
                    Router.instance.homepage(self, back: true)
                } else {
                    Logger.e("Side menu presenter is nil")
                }
            })
        }
        
        menuSettings.setOnClickListener {
            Router.instance.controllerTransition(ControllerTransition.LEFT_TO_RIGHT).startBaseController(self, Controllers.SETTINGS)
        }
        
        menuHelp.setOnClickListener {
            Router.instance.controllerTransition(ControllerTransition.LEFT_TO_RIGHT).startBaseController(self, Controllers.HELP)
        }
        
        menuConsent.setOnClickListener {
            let boundle = Boundle()
            boundle.putBoolean(Extra.FROM_MENU.key, true)
            Router.instance.startBaseController(self, Controllers.CONSENT_FORM, boundle)
        }
        
        menuFinish.setOnClickListener {
            let dialog = WithdrawDialog()
            dialog.setCancelable(true)
            dialog.setConfirmListener {
                Router.instance.logout(self)
            }
            dialog.show()
        }
    }
}
