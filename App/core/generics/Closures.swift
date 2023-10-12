//
//  Closures.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//

import Foundation

public typealias ClosureVoid = () -> ()
public typealias ClosureInt = (Int) -> ()
public typealias ClosureBool = (Bool) -> ()
public typealias ClosureDate = (Date) -> ()
public typealias ClosureDouble = (Double) -> ()
public typealias ClosureString = (String) -> ()
public typealias ClosureConnection = (Int, ConnectionResult, String?) -> ()
