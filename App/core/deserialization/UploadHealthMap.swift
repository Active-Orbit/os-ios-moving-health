//
//  UploadHealthMap.swift
//  App
//
//  Created by Omar Brugna on 22/08/23.
//

import Foundation
import ObjectMapper

class UploadHealthMap : BaseProtocol, Mappable {
    
    var result: String?
    
    required public init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        result <- map["result"]
    }
    
    public func identifier() -> String {
        return Constants.EMPTY
    }
    
    public func isValid() -> Bool {
        return !TextUtils.isEmpty(result)
    }
}
