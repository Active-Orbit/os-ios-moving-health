//
//  HealthManager.swift
//  App
//
//  Created by Omar Brugna on 22/08/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import Foundation

public class HealthManager {
    
    static func uploadHealth(_ controller: BaseController, _ health: DBHealth, _ listener: ResultListener? = nil) {
        if !health.isValid() {
            Logger.d("No health response to upload to server")
            listener?(false)
            return
        }
        
        let request = UploadHealthRequest()
        request.userId = Preferences.user.idUser
        
        let healthRequest = UploadHealthRequest.UploadHealthResponse()
        healthRequest.healthID = Int(health.healthID)!
        healthRequest.timestamp = Int(health.healthTimestamp)
        healthRequest.mobility = health.healthMobility
        healthRequest.selfCare = health.healthSelfCare
        healthRequest.usualActivities = health.healthActivities
        healthRequest.pain = health.healthPain
        healthRequest.anxiety = health.healthAnxiety
        healthRequest.score = health.healthScore
        
        request.healthResponse = healthRequest
        
        let webService = WebService<UploadHealthRequest>(.INSERT_HEALTH, request)
        webService.method = .post
        
        Connection(webService, { tag, connectionResult, response in
            switch connectionResult {
                case .SUCCESS:
                    if !TextUtils.isEmpty(response) {
                        let map: UploadHealthMap? = Gson.toObject(response!)
                        if map?.isValid() == true {
                            if map!.result == "OK" {
                                health.uploaded = true
                                TableHealth.upsert(health)
                                Logger.d("Health uploaded to server for user id \(Preferences.user.idUser ?? Constants.EMPTY) success")
                                listener?(true)
                            } else {
                                Logger.w("Health uploaded to server error for user id \(Preferences.user.idUser ?? Constants.EMPTY)")
                                listener?(false)
                            }
                        } else {
                            Logger.e("Health uploaded to server invalid")
                            listener?(false)
                        }
                    } else {
                        Logger.e("Error uploading health to server empty response")
                        listener?(false)
                    }
                case .ERROR:
                    Logger.e("Error uploading health to server")
                    listener?(false)
                default:
                    break
            }
        }).connect()
    }
    
    public static func checkForNotUploaded(_ controller: BaseController) {
        var modelsNotUploaded = TableHealth.getNotUploaded()
        for model in modelsNotUploaded {
            uploadHealth(controller, model)
            Logger.d("Upload Health: \(model.description())")
        }
    }
}
