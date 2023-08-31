//
//  DBModel.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation
import RealmSwift

/**
 * Base database model that should be extended from other database models
 */
open class DBModel : Object, BaseProtocol {
    
    open func isValid() -> Bool {
        Exception("Is valid method must never be called on the base class")
        return false
    }
    
    open func identifier() -> String {
        Logger.e("Called base identifier method, this should never happen")
        return Constants.EMPTY
    }
}
