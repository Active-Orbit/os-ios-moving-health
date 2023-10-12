//
//  HelpComponent.swift
//  App
//
//  Created by George Stavrou on 04/07/2023.
//

import UIKit

public class HelpComponent: BaseComponent {
    

    @IBOutlet var panel: BaseView!
    @IBOutlet var title: BaseLabel!
    @IBOutlet var panelIcon: BaseView!
    
    public override func onViewPrepared() {
        super.onViewPrepared()
        
        panel.cornerRadius = 10
        panel.borderWidth = 1
        panel.borderColor = ColorProvider.get("colorPrimary")
        
        
        panelIcon.clipsToBounds = true
        panelIcon.layer.cornerRadius = 10
        panelIcon.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        

        //TODO onTouch event
        
    }
    
    public override func getXibName() -> String {
        return "HelpComponent"
    }
    
    public func setTitle(_ title: String) {
        
        self.title.text = title
        
    }
    
    
    
    
    
    
    
    
   
  
}
