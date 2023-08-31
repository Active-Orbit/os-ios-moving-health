//
//  HealthResponseComponent.swift
//  App
//
//  Created by George Stavrou on 12/07/2023.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import UIKit

public class HealthResponseComponent: BaseComponent {
    

    @IBOutlet var healthTypeTitle: BaseLabel!
    @IBOutlet var checkbox: BaseCheckBox!
    @IBOutlet var healthResponse: BaseLabel!
    
    public override func onViewPrepared() {
        super.onViewPrepared()
        
        checkbox.isChecked = true
        checkbox.isEnabled = false
        
    }
    
    public override func getXibName() -> String {
        return "HealthResponseComponent"
    }
    
    
    func setLayout(_ title: String, _ response: String) {
        self.healthTypeTitle.text = title
        self.healthResponse.text = response
        self.checkbox.isChecked = true
    }
}
