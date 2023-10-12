//
//  ConsentFormManager.swift
//  App
//
//  Created by Omar Brugna on 17/07/23.
//

import Foundation

public class ConsentFormManager {

    static func retrieveConsentForm(_ controller: BaseController, _ listener: ResultListener? = nil) {
        
        let webService = WebService<EmptyRequest>(.RETRIEVE_CONSENT_FORM)
        webService.method = .get
        
        Connection(webService, { tag, connectionResult, response in
            switch connectionResult {
                case .SUCCESS:
                    if !TextUtils.isEmpty(response) {
                        var responseFix = response!
                        responseFix.removeFirst()
                        responseFix.removeLast()
                        
                        let map: RetrieveConsentFormMap? = Gson.toObject(responseFix)
                        if map != nil {
                            if map!.isValid() {
                                Logger.d("Consent form downloaded from server \(map!)")
                                TableConsentQuestions.truncate()
                                TableConsentQuestions.upsert(map!.dbQuestions())
                                //TODO check for version. If version has changed show a dialog that they need to consent to the new consent form
                                Preferences.user.consentFormText = map!.consentText!
                                Preferences.user.consentVersion = Utils.numbersFromString(map!.version!)
                                listener?(true)
                            } else {
                                Logger.d("Error consent form")
                                listener?(false)
                            }
                        } else {
                            Logger.e("Error consent form json response")
                            listener?(false)
                        }
                    } else {
                        Logger.e("Error consent form json response")
                        listener?(false)
                    }
                case .ERROR:
                    Logger.e("Error retrieving consent form from server")
                    listener?(false)
                default:
                    break
            }
        }).connect()
    }
}
