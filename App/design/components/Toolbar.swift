//
//  Toolbar.swift
//  BaseApp
//
//  Created by George Stavrou on 05/04/2023.
//

import UIKit
import SideMenu

public class Toolbar: BaseComponent {
    
    @IBOutlet var container: BaseView!
    @IBOutlet weak var leftIconContainer: BaseView!
    @IBOutlet weak var leftIcon: BaseImageView!
    @IBOutlet weak var logo: BaseImageView!
    @IBOutlet weak var title: BaseLabel!
    @IBOutlet weak var menuComponent: MenuComponent!
    @IBOutlet weak var leftIconContainerWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftIconContainerLeadingConstraint: NSLayoutConstraint!
    
    
    public override func getXibName() -> String {
        return "Toolbar"
    }
    
    public override func onViewPrepared() {
        // showShadow()
    }
    
    public func setup(_ controller: BaseController) {
        hideLogo()
        leftIconContainer.setOnClickListener {
            controller.finish()
        }
        menuComponent.setOnClickListener {
            let sideMenu = Controllers.SIDE_MENU.getSideMenuController()
            sideMenu.settings = self.makeSettings()
            (sideMenu.viewControllers.first as? SideMenuController)?.presenter = controller
            controller.present(sideMenu, animated: true, completion: nil)
        }
    }
    
    fileprivate func makeSettings() -> SideMenuSettings {
        var settings = SideMenuSettings()
        settings.allowPushOfSameClassTwice = false
        settings.presentationStyle = .menuSlideIn
        settings.statusBarEndAlpha = 0
        settings.menuWidth = UIScreen.main.bounds.width * 0.8
        return settings
    }
    
    public func setTitle(_ string: String?) {
        title.text = string
        showTitle()
    }
    
    public func setTitleUppercased() {
        title.textAllCaps = true
    }
    
    public func setTitleColor(_ color: UIColor?) {
        title.textColor = color
    }
    
    public func showTitle() {
        title.visibility = .visible
        hideLogo()
    }
    
    public func hideTitle() {
        title.visibility = .invisible
    }
    
    public func showLogo() {
        logo.visibility = .visible
        hideTitle()
    }
    
    public func hideLogo() {
        logo.visibility = .invisible
    }
    
    public func showMenuComponent() {
        menuComponent.visibility = .visible
        hideBackButton()
    }
    
    public func hideMenuComponent() {
        menuComponent.visibility = .invisible
    }
    
    public func setMenuIconPrimary() {
        menuComponent.setIconPrimary()
    }
    
    public func setMenuIconLight() {
        menuComponent.setIconLight()
    }
    
    public func setMenuIconDark() {
        menuComponent.setIconDark()
    }
    
    public func hide() {
        isHidden = true
    }
    
    public func show() {
        isHidden = false
    }
    
    public func setBackgroundColor(_ color: UIColor?) {
        container.backgroundColor = color
    }
    
    public func setBackButtonImage(_ image: UIImage?) {
        leftIcon.image = image
    }
    
    public func showBackButton() {
        leftIcon.visibility = .visible
        leftIconContainer.visibility = .visible
        leftIconContainerWidthConstraint.constant = CGFloat(40)
        leftIconContainerLeadingConstraint.constant = CGFloat(16)
        hideMenuComponent()
    }
    
    public func hideBackButton() {
        leftIcon.visibility = .invisible
        leftIconContainer.visibility = .invisible
        leftIconContainerWidthConstraint.constant = CGFloat(0)
        leftIconContainerLeadingConstraint.constant = CGFloat(9)
    }
}

