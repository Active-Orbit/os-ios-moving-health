//
//  ControllerProvider.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//

import UIKit

public protocol ControllerProvider {
    
    func getController() -> BaseController
}
