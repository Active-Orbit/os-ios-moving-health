//
//  ContactUsController.swift
//  App
//
//  Created by George Stavrou on 06/07/2023.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import UIKit

class ContactUsController: BaseController {


    @IBOutlet var toolbar: Toolbar!
    
    @IBOutlet var screenTitle: BaseLabel!
    @IBOutlet var panel: BaseView!
    
    @IBOutlet var panelTitle: BaseLabel!
    
    @IBOutlet var panelDescription: BaseLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar()
        
        toolbar.setup(self)
        toolbar.showBackButton()
        
        panel.cornerRadius = 10
    }
}
