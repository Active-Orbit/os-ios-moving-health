//
//  MainController.swift
//  App
//
//  Created by George Stavrou on 05/04/2023.
//

import UIKit

class MainController: BaseController {
    
    @IBOutlet var toolbar: Toolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideNavigationBar()
        
        toolbar.setup(self)
        toolbar.showLogo()
        toolbar.showMenuComponent()
    }
}
