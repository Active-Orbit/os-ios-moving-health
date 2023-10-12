//
//  MobilityPanelComponent.swift
//  App
//
//  Created by Omar Brugna on 26/07/2023.
//

import UIKit

public class MobilityPanelComponent: BaseComponent {
    
    @IBOutlet weak var mainView: BaseView!
    @IBOutlet weak var panelTitle: BaseLabel!
    @IBOutlet weak var panelVehicleTrips: BaseLabel!
    @IBOutlet weak var panelVehicleDistance: BaseLabel!
    @IBOutlet weak var panelVehicleMinutes: BaseLabel!
    @IBOutlet weak var panelVehicleMinutesLabel: BaseLabel!
    
    public override func onViewPrepared() {
        super.onViewPrepared()
        
        mainView.cornerRadius = 16
    }
    
    public override func getXibName() -> String {
        return "MobilityPanelComponent"
    }
    
    public func setProgress(_ vehicleTrips: Int, _ vehicleDistance: Double, _ vehicleMinutes: Int) {
        panelVehicleTrips.text = String(vehicleTrips)
        panelVehicleDistance.text = String(format: "%.1f", vehicleDistance)
        panelVehicleMinutes.text = String(vehicleMinutes)

        if vehicleMinutes == 1 { panelVehicleMinutesLabel.text = StringProvider.get("minute") }
        else { panelVehicleMinutesLabel.text = StringProvider.get("minutes") }
    }
    
    public override func setOnClickListener(_ listener: @escaping (() -> Void)) {
        super.setOnClickListener(listener)
        mainView.setOnClickListener(listener)
    }
}
