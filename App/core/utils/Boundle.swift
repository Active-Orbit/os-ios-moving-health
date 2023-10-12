//
//  Boundle.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//

import Foundation

/**
 * Utility class that provides some useful methods to include data into a dictionary
 */
public class Boundle {
    
    fileprivate var objects = Dictionary<String, Any>()
    
    public init() {
        
    }
    
    public func putString(_ key: String, _ value: String?) {
        objects[key] = value
    }
    
    public func getString(_ key: String, _ defaultValue: String? = nil) -> String? {
        return (objects[key] as! String?) ?? defaultValue
    }
    
    public func putInt(_ key: String, _ value: Int) {
        objects[key] = value
    }
    
    public func getInt(_ key: String, _ defaultValue: Int = Constants.INVALID) -> Int {
        return (objects[key] ?? defaultValue) as! Int
    }
    
    public func putDouble(_ key: String, _ value: Double) {
         objects[key] = value
     }
     
     public func getDouble(_ key: String, _ defaultValue: Double = Constants.INVALID_DOUBLE) -> Double {
         return (objects[key] ?? defaultValue) as! Double
     }
    
    public func putBoolean(_ key: String, _ value: Bool) {
        objects[key] = value
    }
    
    public func getBoolean(_ key: String, _ defaultValue: Bool = false) -> Bool {
        return (objects[key] ?? defaultValue) as! Bool
    }
    
    public func putStringArrayList(_ key: String, _ value: [String]?) {
        objects[key] = value
    }
    
    public func getStringArrayList(_ key: String, _ defaultValue: [String]? = nil) -> [String]? {
        return (objects[key] as! [String]?) ?? defaultValue
    }
    
    public func putExtra(_ key: String, _ value: Any?) {
        objects[key] = value
    }
    
    public func get(_ key: String, _ defaultValue: Any? = nil) -> Any? {
        return objects[key] ?? defaultValue
    }
}
