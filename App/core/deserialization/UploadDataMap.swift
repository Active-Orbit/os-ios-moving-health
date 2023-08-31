//
//  UploadDataMap.swift
//  App
//
//  Created by Omar Brugna on 23/08/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import Foundation
import ObjectMapper

class UploadDataMap : BaseProtocol, Mappable {
    
    var result: String?
    var errorCode: String?
    var option: String?
    
    required public init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        result <- map["result"]
        errorCode <- map["error_code"]
        option <- map["option"]
    }
    
    public func identifier() -> String {
        return Constants.EMPTY
    }
    
    public func isValid() -> Bool {
        return result == "success"
    }
}
