//
//  NumberExtension.swift
//  App
//
//  Created by Omar Brugna on 27/07/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import Foundation

extension BinaryInteger {
    var degreesToRadians: CGFloat { CGFloat(self) * .pi / 180 }
}

extension FloatingPoint {
    var degreesToRadians: Self { self * .pi / 180 }
    var radiansToDegrees: Self { self * 180 / .pi }
}
