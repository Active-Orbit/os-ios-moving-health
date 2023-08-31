//
//  SideMenuComponent.swift
//  App
//
//  Created by Omar Brugna on 28/06/2023.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import UIKit

public class SideMenuComponent: BaseComponent {
    
    @IBOutlet weak var menuImage: BaseImageView!
    @IBOutlet weak var menuLabel: BaseLabel!
    
    public override func onViewPrepared() {
        super.onViewPrepared()
        
    }
    
    public override func getXibName() -> String {
        return "SideMenuComponent"
    }
    
    public func setup(_ icon: UIImage?, _ text: String) {
        setImage(icon)
        setLabel(text)
    }
    
    public func setImage(_ icon: UIImage?) {
        menuImage.image = icon
    }
    
    public func setLabel(_ text: String) {
        menuLabel.text = text
    }
}
