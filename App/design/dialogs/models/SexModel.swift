//
//  SexModel.swift
//  App
//
//  Created by Omar Brugna on 11/07/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import Foundation

public class SexModel : BaseProtocol {
    
    public var sex: String
    
    init(_ sex: String) {
        self.sex = sex
    }
    
    public func identifier() -> String {
        return sex
    }
    
    public func isValid() -> Bool {
        return !TextUtils.isEmpty(sex)
    }
}
