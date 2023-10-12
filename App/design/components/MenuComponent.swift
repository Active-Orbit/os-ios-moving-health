//
//  MenuComponent.swift
//  App
//
//  Created by George Stavrou on 05/04/2023.
//

import UIKit

public class MenuComponent: BaseComponent {
    
    @IBOutlet weak var image: BaseImageView!
    
    public override func onViewPrepared() {
        super.onViewPrepared()
        
    }
    
    public override func getXibName() -> String {
        return "MenuComponent"
    }
    
    public func setIconDark() {
        image.image = ImageProvider.get("ic_menu_dark")
    }
    
    public func setIconLight() {
        image.image = ImageProvider.get("ic_menu_light")
    }
    
    public func setIconPrimary() {
        image.image = ImageProvider.get("ic_menu_primary")
    }
}
