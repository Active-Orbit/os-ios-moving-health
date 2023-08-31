//
//  ConsentPrivacyController.swift
//  BaseApp
//
//  Created by Omar Brugna on 17/08/2023.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import UIKit
import Tracker
import WebKit

class ConsentPrivacyController: BaseController {
    
    @IBOutlet var toolbar: Toolbar!
    @IBOutlet var mainView: BaseView!
    @IBOutlet var topContainer: UIView!
    @IBOutlet var stepOne: UIView!
    @IBOutlet var stepTwo: UIView!
    @IBOutlet var stepThree: UIView!
    @IBOutlet var stepFour: UIView!
    @IBOutlet var backBtn: BaseButton!
    @IBOutlet var confirmBtn: BaseButton!
    @IBOutlet var scrollView: BaseScrollView!
    @IBOutlet var stepsLayout: UIView!
    @IBOutlet var buttonsLayout: UIView!
    
    @IBOutlet var privacyLink: BaseLabel!
    @IBOutlet var consentText: BaseLabel!
    @IBOutlet var bottomScrollVerticalConstraint: NSLayoutConstraint!
    @IBOutlet var bottomSafeAreaVerticalConstraint: NSLayoutConstraint!
    
    @IBOutlet var nextButtonLeadingToBackButtonConstraint: NSLayoutConstraint!
    @IBOutlet var nextButtonLeadingToSafeAreaConstraint: NSLayoutConstraint!
    
    fileprivate var manageWebViewHeight = false
    
    fileprivate var fromMenu = false
    fileprivate var fromHelp = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar()
        
        toolbar.setup(self)
        toolbar.hideMenuComponent()
        
        fromMenu = controllerBoundle.getBoolean(Extra.FROM_MENU.key)
        fromHelp = controllerBoundle.getBoolean(Extra.FROM_HELP.key)
        
        if fromMenu || fromHelp { toolbar.showBackButton() }
        
        prepare()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
        
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deregisterForKeyboardNotifications()
        
    }
    
    
    fileprivate func prepare() {
        
        topContainer.cornerRadius = 10
        
        stepOne.cornerRadius = 5
        stepTwo.cornerRadius = 5
        stepThree.cornerRadius = 5
        stepFour.cornerRadius = 5
        
        let attributedString = NSMutableAttributedString.init(string: StringProvider.get("privacy_policy"))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange.init(location: 0, length: attributedString.length))
        privacyLink.attributedText = attributedString
        
        privacyLink.setOnClickListener {
            Router.instance.openPrivacy()
        }
        
        
        let htmlStringFixed = Preferences.user.consentFormText.replacingOccurrences(of: "<![CDATA[", with: "").replacingOccurrences(of: "]]>", with: "")
        
        consentText.attributedText = htmlStringFixed.htmlToAttributedString(size: TextSizeProvider.getTextSize(index: 5), color: ColorProvider.get("textColorPrimaryDark")!, font: FontProvider.getFontName(index: 0),allignment: Constants.ALIGN_TEXT_LEFT)
        
    
        if fromMenu {
            
            stepsLayout.visibility = .invisible
            buttonsLayout.visibility = .invisible
            
            backBtn.visibility = .visible
            nextButtonLeadingToSafeAreaConstraint.priority = UILayoutPriority(999)
            nextButtonLeadingToBackButtonConstraint.priority = UILayoutPriority(1000)
            backBtn.setOnClickListener {
                self.finish()
            }
            
            bottomScrollVerticalConstraint.priority = UILayoutPriority(999)
            bottomSafeAreaVerticalConstraint.constant = 20
            bottomSafeAreaVerticalConstraint.priority = UILayoutPriority(1000)
            
        } else {
            
            stepsLayout.visibility = .visible
            buttonsLayout.visibility = .visible
            
            confirmBtn.setOnClickListener {
                Router.instance.controllerTransition(ControllerTransition.LEFT_TO_RIGHT).startBaseController(self, Controllers.CONSENT_FORM)
            }
            
            nextButtonLeadingToBackButtonConstraint.priority = UILayoutPriority(999)
            nextButtonLeadingToSafeAreaConstraint.priority = UILayoutPriority(1000)
            backBtn.visibility = .invisible
        }
    }
}

