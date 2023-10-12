//
//  FaqProvider.swift
//  App
//
//  Created by George Stavrou on 02/12/2020.
//

import UIKit

/**
 * Utility class that should be used to manage
 * questions and answers
 */
public class FaqProvider {
    
    fileprivate static var mInstance: FaqProvider?
    
    public static var instance: FaqProvider {
        get {
            if mInstance == nil {
                mInstance = FaqProvider()
                mInstance!.initialize()
            }
            return mInstance!
        }
    }
    
    public var faqs = [FaqModel]()
    
    fileprivate func initialize() {
        
        let category1 = FaqModel(category: StringProvider.get("faq_categories_1"))
        let category1sub1 = FaqModel(category: StringProvider.get("faq_questions_general_1"))
        let category1sub2 = FaqModel(category: StringProvider.get("faq_questions_general_2"))
        let category1sub3 = FaqModel(category: StringProvider.get("faq_questions_general_3"))
        let category1sub4 = FaqModel(category: StringProvider.get("faq_questions_general_4"))
        let category1sub5 = FaqModel(category: StringProvider.get("faq_questions_general_5"))
        let category1sub6 = FaqModel(category: StringProvider.get("faq_questions_general_6"))
        let category1sub7 = FaqModel(category: StringProvider.get("faq_questions_general_7"))
        let category1sub8 = FaqModel(category: StringProvider.get("faq_questions_general_8"))
        let category1sub9 = FaqModel(category: StringProvider.get("faq_questions_general_9"))
        
        let category2 = FaqModel(category: StringProvider.get("faq_categories_2"))
        let category2sub1 = FaqModel(category: StringProvider.get("faq_questions_setup_1"))
        let category2sub2 = FaqModel(category: StringProvider.get("faq_questions_setup_2"))
        let category2sub3 = FaqModel(category: StringProvider.get("faq_questions_setup_3"))
        
        let category3 = FaqModel(category: StringProvider.get("faq_categories_3"))
        let category3sub1 = FaqModel(category: StringProvider.get("faq_questions_technical_1"))
        let category3sub2 = FaqModel(category: StringProvider.get("faq_questions_technical_2"))
        
        let category1sub1Response = FaqModel(question: category1sub1.category, answer: StringProvider.get("faq_answers_1"))
        let category1sub2Response = FaqModel(question: category1sub2.category, answer: StringProvider.get("faq_answers_2"))
        let category1sub3Response = FaqModel(question: category1sub3.category, answer: StringProvider.get("faq_answers_3"))
        let category1sub4Response = FaqModel(question: category1sub4.category, answer: StringProvider.get("faq_answers_4"))
        let category1sub5Response = FaqModel(question: category1sub5.category, answer: StringProvider.get("faq_answers_5"))
        let category1sub6Response = FaqModel(question: category1sub6.category, answer: StringProvider.get("faq_answers_6"))
        let category1sub7Response = FaqModel(question: category1sub7.category, answer: StringProvider.get("faq_answers_7"))
        let category1sub8Response = FaqModel(question: category1sub8.category, answer: StringProvider.get("faq_answers_8"))
        let category1sub9Response = FaqModel(question: category1sub9.category, answer: StringProvider.get("faq_answers_9"))
        
        let category2sub1Response = FaqModel(question: category2sub1.category, answer: StringProvider.get("faq_answers_10"))
        let category2sub2Response = FaqModel(question: category2sub2.category, answer: StringProvider.get("faq_answers_11"))
        let category2sub3Response = FaqModel(question: category2sub3.category, answer: StringProvider.get("faq_answers_12"))
        
        let category3sub1Response = FaqModel(question: category3sub1.category, answer: StringProvider.get("faq_answers_13"))
        let category3sub2Response = FaqModel(question: category3sub2.category, answer: StringProvider.get("faq_answers_14"))
        
        category1.position = 1
        category2.position = 2
        category3.position = 3
        category1sub1.position = 4
        category1sub2.position = 5
        category1sub3.position = 6
        category1sub4.position = 7
        category1sub5.position = 8
        category1sub6.position = 9
        category1sub7.position = 10
        category1sub8.position = 11
        category1sub9.position = 12
        category2sub1.position = 13
        category2sub2.position = 14
        category2sub3.position = 15
        category3sub1.position = 16
        category3sub2.position = 17
        category1sub1Response.position = 18
        category1sub2Response.position = 19
        category1sub3Response.position = 20
        category1sub4Response.position = 21
        category1sub5Response.position = 22
        category1sub6Response.position = 23
        category1sub7Response.position = 24
        category1sub8Response.position = 25
        category1sub9Response.position = 26
        category2sub1Response.position = 27
        category2sub2Response.position = 28
        category2sub3Response.position = 29
        category3sub1Response.position = 30
        category3sub2Response.position = 31
        
        category1sub1.response = category1sub1Response
        category1sub2.response = category1sub2Response
        category1sub3.response = category1sub3Response
        category1sub4.response = category1sub4Response
        category1sub5.response = category1sub5Response
        category1sub6.response = category1sub6Response
        category1sub7.response = category1sub7Response
        category1sub8.response = category1sub8Response
        category1sub9.response = category1sub9Response
        category2sub1.response = category2sub1Response
        category2sub2.response = category2sub2Response
        category2sub3.response = category2sub3Response
        category3sub1.response = category3sub1Response
        category3sub2.response = category3sub2Response
        
        category1.subCategories.append(category1sub1)
        category1.subCategories.append(category1sub2)
        category1.subCategories.append(category1sub3)
        category1.subCategories.append(category1sub4)
        category1.subCategories.append(category1sub5)
        category1.subCategories.append(category1sub6)
        category1.subCategories.append(category1sub7)
        category1.subCategories.append(category1sub8)
        category1.subCategories.append(category1sub9)
        category2.subCategories.append(category2sub1)
        category2.subCategories.append(category2sub2)
        category2.subCategories.append(category2sub3)
        category3.subCategories.append(category3sub1)
        category3.subCategories.append(category3sub2)
        
        let root = FaqModel(category: StringProvider.get("faqs"))
        root.position = 0
        root.subCategories.append(category1)
        root.subCategories.append(category2)
        root.subCategories.append(category3)
        faqs.append(root)
    }
    
    public func getById(_ position: Int) -> FaqModel {
        return getById(faqs, position)
    }
    
    fileprivate func getById(_ models: [FaqModel], _ position: Int) -> FaqModel {
        for model in models {
            if model.position == position {
                return model
            }
            if !model.subCategories.isEmpty {
                let subModel = getById(model.subCategories, position)
                if subModel.isValid() {
                    return subModel
                }
            }
        }
        Logger.e("Faq with position \(position) not found")
        return FaqModel(category: Constants.EMPTY)
    }
}
