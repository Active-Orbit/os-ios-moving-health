//
//  BaseRequest.swift
//  App
//
//  Created by Omar Brugna on 04/11/2020.
//

import Foundation

/**
 * Base request that should be implemented by all the encodable requests
 */
public protocol BaseRequest: BaseProtocol, Encodable {
    
    func toJson() -> String?
}
