//
//  CheckBoxComponent.swift
//  App
//
//  Created by George Stavrou on 10/07/2023.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import UIKit

public class CheckBoxComponent: BaseComponent {
    

    @IBOutlet var label: BaseLabel!
    @IBOutlet var checkbox: BaseCheckBox!
    
    public override func onViewPrepared() {
        super.onViewPrepared()
        
        checkbox.isChecked = false
        
    }
    
    public override func getXibName() -> String {
        return "CheckBoxComponent"
    }
    
    
    func setLabel(_ label: String) {
        self.label.text = label
    }
    
    
    func isChecked() -> Bool {
        return checkbox.isChecked
    }
    
    func setStatus(_ status: Bool) {
        checkbox.isChecked = status
    }
    

}
