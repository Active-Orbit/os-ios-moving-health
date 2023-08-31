//
//  MainPanelComponent.swift
//  App
//
//  Created by Omar Brugna on 28/06/2023.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import UIKit

public class MainPanelComponent: BaseComponent {
    
    @IBOutlet weak var mainView: BaseView!
    @IBOutlet weak var panelImage: BaseImageView!
    @IBOutlet weak var panelIcon: BaseImageView!
    @IBOutlet weak var panelDescription: BaseLabel!
    @IBOutlet weak var panelButton: BaseButton!
    
    fileprivate var panelType = MainPanelType.UNDEFINED
    
    public override func onViewPrepared() {
        super.onViewPrepared()
        
        mainView.cornerRadius = 16
        mainView.borderWidth = 1
        mainView.borderColor = ColorProvider.get("colorPrimary")
    }
    
    public override func getXibName() -> String {
        return "MainPanelComponent"
    }
    
    public func setPanel(_ type: MainPanelType, _ programmeName: String? = Constants.EMPTY) {
        panelType = type
        panelButton.title = panelType.buttonText
        panelIcon.image = panelType.icon
        panelImage.image = panelType.image
        
        if panelType == MainPanelType.START_STUDY_WITH_NAME && programmeName != nil {
            panelDescription.text = String(format: panelType.description, programmeName!)
        } else {
            panelDescription.text = panelType.description
        }
    }
    
    public override func setOnClickListener(_ listener: @escaping (() -> Void)) {
        super.setOnClickListener(listener)
        panelButton.setOnClickListener(listener)
    }
}
