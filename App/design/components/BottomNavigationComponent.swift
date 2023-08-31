//
//  BottomNavigationComponent.swift
//  App
//
//  Created by George Stavrou on 25/07/2023.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import UIKit

public class BottomNavigationComponent: BaseComponent {
    
    @IBOutlet weak var navTrips: BottomNavItemComponent!
    @IBOutlet weak var navHealth: BottomNavItemComponent!
    @IBOutlet weak var navMain: BottomNavItemComponent!
    
    private var selectedType = BottomNavItemType.MAIN
    
    public override func onViewPrepared() {
        super.onViewPrepared()
        
    }
    
    public override func getXibName() -> String {
        return "BottomNavigationComponent"
    }
    
    func setSelected(_ navType: BottomNavItemType, _ controller: BaseController) {
        selectedType = navType
        switch (selectedType) {
            case BottomNavItemType.MAIN:
                navTrips.setImage("bottom_nav_trips_idle")
                navHealth.setImage("bottom_nav_health_idle")
                navMain.setImage("bottom_nav_main_selected")
            case BottomNavItemType.TRIPS:
                navTrips.setImage("bottom_nav_trips_selected")
                navHealth.setImage("bottom_nav_health_idle")
                navMain.setImage("bottom_nav_main_idle")
            case BottomNavItemType.HEALTH:
                navTrips.setImage("bottom_nav_trips_idle")
                navHealth.setImage("bottom_nav_health_selected")
                navMain.setImage("bottom_nav_main_idle")
        }
        setOnClickListeners(controller)
    }
    
    
    private func setOnClickListeners(_ controller: BaseController) {
        navTrips.setOnClickListener {
            let provider = Controllers.ACTIVITIES
            if !Router.instance.backToController(controller, provider) {
                Router.instance.controllerTransition(ControllerTransition.FADE).startBaseController(controller, provider)
            }
        }
        navHealth.setOnClickListener {
            let provider = Controllers.HEALTH
            if !Router.instance.backToController(controller, provider) {
                Router.instance.controllerTransition(ControllerTransition.FADE).startBaseController(controller, provider)
            }
        }
        navMain.setOnClickListener {
            Router.instance.homepage(controller, back: true)
        }
    }
}
