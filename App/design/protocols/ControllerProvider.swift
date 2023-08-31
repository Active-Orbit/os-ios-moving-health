//
//  ControllerProvider.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import UIKit

public protocol ControllerProvider {
    
    func getController() -> BaseController
}
