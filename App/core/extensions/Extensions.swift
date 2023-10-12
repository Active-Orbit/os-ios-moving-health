//
//  Extensions.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//

import UIKit

public typealias JSONDict = [String: Any]
public typealias JSONArray = [JSONDict]

let mainApplication = UIApplication.shared.delegate as! AppDelegate
let mainBundle = Bundle.main
let defaultsStandard = Foundation.UserDefaults.standard

public func mainThread(_ runnable: @escaping () -> ()) {
    DispatchQueue.main.async {
        runnable()
    }
}

public func backgroundThread(_ runnable: @escaping () -> ()) {
    DispatchQueue.global(qos: .background).async {
        runnable()
    }
}

public func classNameFor(_ type: Any.Type) -> String {
    return String(describing: object_getClassName(type))
}

extension NSObject {
    
    public var className : String {
        return String(describing: object_getClassName(self))
    }
}
