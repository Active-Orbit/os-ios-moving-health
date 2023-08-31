//
//  FaqModel.swift
//  App
//
//  Created by George Stavrou on 02/12/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

public class FaqModel: BaseProtocol {
    
    public var position = Constants.INVALID
    public var category = Constants.EMPTY
    public var subCategories = [FaqModel]()
    public var response: FaqModel?
    public var question = Constants.EMPTY
    public var answer = Constants.EMPTY
    
    init(question: String, answer: String) {
        self.question = question
        self.answer = answer
    }
    
    init(category: String) {
        self.category = category
    }
        
    open func isValid() -> Bool {
        return position != Constants.INVALID && (hasSubCategories() || hasResponse())
    }
    
    public func identifier() -> String {
        return String(position)
    }
    
    public func hasSubCategories() -> Bool {
        return !subCategories.isEmpty
    }
    
    public func hasResponse() -> Bool {
        return response != nil
    }
}
