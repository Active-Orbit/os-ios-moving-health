//
//  Validator.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

/**
 * Utility class that provides some useful methods for data validation
 */
class Validator {
    
    /**
     Validate mail address
     - parameter mail address string to validate
     - returns: true if mail address is valid
     */
    static func validateMail(_ mailAddress: String?) -> Bool {
        if TextUtils.isEmpty(mailAddress) {
            return false
        }
        let regex = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: mailAddress)
    }
    
    /**
     Validate url
     - parameter website string to validate
     - returns: true if website is valid
     */
    static func validateUrl(_ url: String?) -> Bool {
        if TextUtils.isEmpty(url) {
            return false
        }
        let regex = "^(http://|https://)?(www.)?([a-zA-Z0-9]+).[a-zA-Z0-9]*\\.[a-z]{3}.?([a-zA-Z0-9-_.]+)?$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: url)
    }
    
    static func validatePostcode(_ postcode: String?) -> Bool {
        if TextUtils.isEmpty(postcode) {
            return false
        }
        let regex = "^([Gg][Ii][Rr] 0[Aa]{2})|((([A-Za-z][0-9]{1,2})|(([A-Za-z][A-Ha-hJ-Yj-y][0-9]{1,2})|(([AZa-z][0-9][A-Za-z])|([A-Za-z][A-Ha-hJ-Yj-y][0-9]?[A-Za-z])))) [0-9][A-Za-z]{2})$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: postcode)
    }
    
    static func validateNhsNumber(_ number: String?) -> Bool {
        if TextUtils.isEmpty(number) {
            return false
        }
        var total = 0
        var multiplyWith = 10


        if number!.count == 10 {
            var index = 0
            number!.forEach({ character in
                if index == number!.count - 1 {
                    
                } else {
                    let a = character.wholeNumberValue! * multiplyWith
                    multiplyWith -= 1
                    total += a
                }
                index += 1
            })

            let remainder = total % 11
            let digit = 11 - remainder

            var summary = 0
            switch digit {
                case 10: return false
                case 11: summary = 0
                default: summary = digit
            }
            return summary == number!.last!.wholeNumberValue!
        }
        return false
    }
    
    
    static func validatePhone(_ phone: String) -> Bool {
        if TextUtils.isEmpty(phone) {
            return false
        }
        
        let regex = "^((\\+44)|(0)) ?\\d{4} ?\\d{6}?$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: phone)
        
    }
}

