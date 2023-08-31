//
//  TableHealth.swift
//  App
//
//  Created by George Stavrou on 13/07/2023.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import Foundation
import RealmSwift


public class TableHealth {
    
    public static func getAll(detached: Bool = true) -> [DBHealth] {
        let results = Database.instance.database.objects(DBHealth.self)
        let models = detached ? results.detached : Array(results)
        return models
    }
    
    
    public static func getById(_ healthID: String, detached: Bool = true) -> DBHealth? {
        let predicate = NSPredicate(format: "healthID = %@", healthID)
        let result = Database.instance.database.objects(DBHealth.self).filter(predicate).first
        return detached ? result?.detached() : result
    }
    
    public static func getNotUploaded(detached: Bool = true) -> [DBHealth] {
        let results = Database.instance.database.objects(DBHealth.self).where {
            !$0.uploaded
        }
        let models = detached ? results.detached : Array(results)
        return models
    }
    
    public static func upsert(_ model: DBHealth) {
        upsert([model])
    }
    
    public static func upsert(_ models: [DBHealth]) {
        do {
            Database.instance.beginWrite()
            Database.instance.database.add(models.detached, update: .modified)
            try Database.instance.commitWrite()
        } catch {
            Logger.e("Error on upsert healths to database \(error.localizedDescription)")
        }
    }
    
    public static func truncate() {
        do {
            let models = getAll(detached: false)
            Database.instance.beginWrite()
            Database.instance.database.delete(models)
            try Database.instance.commitWrite()
        } catch {
            Logger.e("Error on truncate healths from database \(error.localizedDescription)")
        }
    }
}
