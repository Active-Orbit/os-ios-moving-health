//
//  Gson.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 * Utility class that provides some useful methods for json serialization and deserialization
 */
public class Gson {
    
    public static func toJsonData<T : Encodable>(_ encodable: T) -> Data? {
        do {
            let jsonEncoder = JSONEncoder()
            return try jsonEncoder.encode(encodable)
        } catch {
            Logger.e("Error on json encoding \(error.localizedDescription)")
        }
        return nil
    }
    
    public static func toJsonString<T : Encodable>(_ encodable: T) -> String? {
        let jsonData = toJsonData(encodable)
        if jsonData != nil {
            return String(data: jsonData!, encoding: .utf8)
        }
        return nil
    }
    
    public static func toObject<T : Mappable>(_ json: String) -> T? {
        return Mapper<T>().map(JSONString: json)
    }
    
    public static func toArray<T : Mappable>(_ json: String) -> [T]? {
        return Mapper<T>().mapArray(JSONString: json)
    }
}

extension Collection where Iterator.Element == JSONDict {
    
    public func toJson(_ options: JSONSerialization.WritingOptions = .prettyPrinted) -> String {
        var json = "[]"
        if self is JSONArray {
            let data = try? JSONSerialization.data(withJSONObject: self as! JSONArray, options: options)
            let string = String(data: data!, encoding: .utf8)
            if !TextUtils.isEmpty(string) { json = string! }
        }
        return json
    }
}
