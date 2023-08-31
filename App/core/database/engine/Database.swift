//
//  Database.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation
import RealmSwift

/**
 * Main database class
 */
public class Database {
    
    public static let instance = Database()
    public var database: Realm!
    
    init() {
        
        var fileUrl: URL? = nil
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        if let applicationSupportURL = urls.last {
            do {
                try fileManager.createDirectory(at: applicationSupportURL, withIntermediateDirectories: true, attributes: nil)
                fileUrl = applicationSupportURL.appendingPathComponent("active_orbit.realm")
            } catch let error {
                Logger.e("Error on realm configuration \(error.localizedDescription)")
            }
        }
        
        var config = Realm.Configuration()
        config.fileURL = fileUrl
        config.schemaVersion = 2
        config.objectTypes = [DBAnalyse.self, DBConsentQuestion.self, DBHealth.self]
        config.encryptionKey = Data(base64Encoded: Constants.DATABASE_ENCRYPTION_KEY)
        
        do {
            database = try Realm(configuration: config)
        } catch {
            Logger.e("Error initializing database \(error.localizedDescription)")
        }
    }
    
    public func beginWrite() {
        if !database.isInWriteTransaction {
            database.beginWrite()
        }
    }
    
    public func commitWrite() throws {
        if database.isInWriteTransaction {
            try database.commitWrite()
        } else {
            Logger.e("Commit write while not in a write transaction")
        }
    }
    
    public func logout() {
        do {
            try database.write {
                database.deleteAll()
            }
        } catch {
            Logger.e("Error trying to clear database \(error.localizedDescription)")
        }
    }
}
