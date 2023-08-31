//
//  EmptyRequest.swift
//  App
//
//  Created by Omar Brugna on 04/11/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

public class EmptyRequest: BaseRequest {
    
    public func isValid() -> Bool {
        return true
    }
    
    public func identifier() -> String {
        return Constants.EMPTY
    }
    
    public func toJson() -> String? {
        return "{}"
    }
}
