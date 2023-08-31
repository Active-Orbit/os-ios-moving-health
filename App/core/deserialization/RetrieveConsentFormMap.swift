//
//  UserRegistrationMap.swift
//  App
//
//  Created by Omar Brugna on 17/07/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import Foundation
import ObjectMapper

class RetrieveConsentFormMap : BaseProtocol, Mappable {
    
    var consentText: String?
    var version: String?
    var questions = [QuestionsDataItem]()
    
    required public init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        consentText <- map["consentText"]
        version <- map["version"]
        questions <- map["questions"]
    }
    
    public func identifier() -> String {
        return Constants.EMPTY
    }
    
    public func isValid() -> Bool {
        return !TextUtils.isEmpty(consentText) &&
        !TextUtils.isEmpty(version) &&
        !questions.isEmpty
    }
    
    class QuestionsDataItem : BaseProtocol, Mappable {
        
        var id = Constants.INVALID
        var question: String?
        
        required public init?(map: Map) {
            
        }
        
        open func mapping(map: Map) {
            id <- map["id"]
            question <- map["question"]
        }
        
        public func identifier() -> String {
            return Constants.EMPTY
        }
        
        public func isValid() -> Bool {
            return id != Constants.INVALID &&
                !TextUtils.isEmpty(question)
        }
    }
    
    func dbQuestions() -> [DBConsentQuestion] {
        var questionsList = [DBConsentQuestion]()
        if !questions.isEmpty {
            for question in questions {
                if question.isValid() {
                    let model = DBConsentQuestion()
                    model.questionID = String(question.id)
                    model.questionText = question.question
                    questionsList.append(model)
                }
            }
        }
        return questionsList
    }
}
