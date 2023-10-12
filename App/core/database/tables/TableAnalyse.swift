//
//  TableAnalyse.swift
//  App
//
//  Created by Omar Brugna on 31/07/23.
//

import Foundation
import RealmSwift

/**
 * Utility class used to manage database analyse
 */
public class TableAnalyse {
    
    public static func getAll(detached: Bool = true) -> [DBAnalyse] {
        let results = Database.instance.database.objects(DBAnalyse.self).sorted(byKeyPath: "timeInMillis", ascending: false)
        let models = detached ? results.detached : Array(results)
        return models
    }
    
    public static func getById(_ analyseId: String, detached: Bool = true) -> DBAnalyse? {
        let predicate = NSPredicate(format: "analyseId = %@", analyseId)
        let result = Database.instance.database.objects(DBAnalyse.self).filter(predicate).first
        return detached ? result?.detached() : result
    }
    
    
    public static func upsert(_ model: DBAnalyse) {
        upsert([model])
    }
    
    public static func upsert(_ models: [DBAnalyse]) {
        do {
            Database.instance.beginWrite()
            Database.instance.database.add(models.detached, update: .modified)
            try Database.instance.commitWrite()
        } catch {
            Logger.e("Error on upsert analyse to database \(error.localizedDescription)")
        }
    }
    

    
    public static func truncate() {
        do {
            let models = getAll(detached: false)
            Database.instance.beginWrite()
            Database.instance.database.delete(models)
            try Database.instance.commitWrite()
        } catch {
            Logger.e("Error on truncate analyse from database \(error.localizedDescription)")
        }
    }
}
