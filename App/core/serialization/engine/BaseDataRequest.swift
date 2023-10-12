//
//  BaseDataRequest.swift
//  App
//
//  Created by Omar Brugna on 04/11/2020.
//

import Foundation

public class BaseDataRequest<T : BaseRequest>: BaseRequest {
    
    fileprivate enum CodingKeys: String, CodingKey {
        case data

        var rawValue: String {
            get {
                switch self {
                    case .data: return "data"
                }
            }
        }
    }

    public var data: T?
    
    public func isValid() -> Bool {
        return data?.isValid() == true
    }

    public func identifier() -> String {
        return Constants.EMPTY
    }
    
    open func toJson() -> String? {
        return Gson.toJsonString(self)
    }
}
