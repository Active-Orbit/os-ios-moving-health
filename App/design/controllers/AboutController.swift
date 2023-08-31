//
//  AboutController.swift
//  App
//
//  Created by Omar Brugna on 30/11/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import UIKit

class AboutController: BaseController {

    @IBOutlet var toolbar: Toolbar!
    @IBOutlet weak var appVersion: BaseLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar()
        
        toolbar.setup(self)
        toolbar.showBackButton()
        
        
        appVersion.text = Utils.getVersionName()
    }
}
