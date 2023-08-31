//
//  TableConsentQuestions.swift
//  App
//
//  Created by Omar Brugna on 17/07/2023.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import Foundation
import RealmSwift


public class TableConsentQuestions {
    
    public static func getAll(detached: Bool = true) -> [DBConsentQuestion] {
        let results = Database.instance.database.objects(DBConsentQuestion.self)
        let models = detached ? results.detached : Array(results)
        return models
    }
    
    
    public static func getById(_ questionID: String, detached: Bool = true) -> DBConsentQuestion? {
        let predicate = NSPredicate(format: "questionID = %@", questionID)
        let result = Database.instance.database.objects(DBConsentQuestion.self).filter(predicate).first
        return detached ? result?.detached() : result
    }
    
    public static func upsert(_ model: DBConsentQuestion) {
        upsert([model])
    }
    
    public static func upsert(_ models: [DBConsentQuestion]) {
        do {
            Database.instance.beginWrite()
            Database.instance.database.add(models.detached, update: .modified)
            try Database.instance.commitWrite()
        } catch {
            Logger.e("Error on upsert consent questions to database \(error.localizedDescription)")
        }
    }
    
    public static func truncate() {
        do {
            let models = getAll(detached: false)
            Database.instance.beginWrite()
            Database.instance.database.delete(models)
            try Database.instance.commitWrite()
        } catch {
            Logger.e("Error on truncate consent questions from database \(error.localizedDescription)")
        }
    }
}
