//
//  TourComponent.swift
//  App
//
//  Created by Omar Brugna on 03/07/2023.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import UIKit

public class TourComponent: BaseComponent {
    
    @IBOutlet weak var mainView: BaseView!
    @IBOutlet weak var tourIconContainer: UIView!
    @IBOutlet weak var tourIcon: BaseImageView!
    @IBOutlet weak var tourDescription: BaseLabel!
    
    public override func onViewPrepared() {
        super.onViewPrepared()
        
        tourIconContainer.cornerRadius = 16
    }
    
    public override func getXibName() -> String {
        return "TourComponent"
    }
    
    public func setup(_ icon: UIImage?, _ description: String) {
        tourIcon.image = icon
        tourDescription.text = description
    }
}
