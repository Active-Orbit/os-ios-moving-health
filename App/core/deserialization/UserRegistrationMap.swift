//
//  UserRegistrationMap.swift
//  App
//
//  Created by Omar Brugna on 14/04/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import Foundation
import ObjectMapper

class UserRegistrationMap : BaseProtocol, Mappable {
    
    var dataItem: DataItem?
    
    required public init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        dataItem <- map["Item"]
    }
    
    public func identifier() -> String {
        return Constants.EMPTY
    }
    
    public func isValid() -> Bool {
        return dataItem?.isValid() == true
    }
    
    class DataItem : BaseProtocol, Mappable {
        
        var userId: UserId?
        var participantIdCounter: ParticipantIdCounter?
        
        required public init?(map: Map) {
            
        }
        
        open func mapping(map: Map) {
            userId <- map["userId"]
            participantIdCounter <- map["participantIdCounter"]
        }
        
        public func identifier() -> String {
            return Constants.EMPTY
        }
        
        public func isValid() -> Bool {
            return userId?.isValid() == true && participantIdCounter?.isValid() == true
        }
        
        class UserId : BaseProtocol, Mappable {
            
            var id = Constants.EMPTY
            
            required public init?(map: Map) {
                
            }
            
            open func mapping(map: Map) {
                id <- map["S"]
            }
            
            public func identifier() -> String {
                return Constants.EMPTY
            }
            
            public func isValid() -> Bool {
                return !TextUtils.isEmpty(id)
            }
        }
        
        class ParticipantIdCounter : BaseProtocol, Mappable {
            
            var counter = Constants.EMPTY
            
            required public init?(map: Map) {
                
            }
            
            open func mapping(map: Map) {
                counter <- map["N"]
            }
            
            public func identifier() -> String {
                return Constants.EMPTY
            }
            
            public func isValid() -> Bool {
                return !TextUtils.isEmpty(counter)
            }
        }
    }
}
