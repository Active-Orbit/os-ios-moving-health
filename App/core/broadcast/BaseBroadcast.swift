//
//  BaseBroadcast.swift
//  App
//
//  Created by Omar Brugna on 26/04/21.
//

import Foundation

/**
* Utility class used to notify events between controllers
*/
public class BaseBroadcast {
    
    public static let ACTIVITIES_LOADING = "activities_loading"
    public static let ACTIVITIES_UPDATED = "activities_updated"
    public static let APPLICATION_FOREGROUND = "application_foreground"
    
    public static let TRACKER_DATA_UPDATED = "tracker_data_updated"

    fileprivate static let SENDER_ID_KEY = "sender_id"
    fileprivate static let IDENTIFIER_KEY = "identifier"
    fileprivate static let IDENTIFIER_SUB_KEY = "identifier_sub"
    
    fileprivate var mHost: BroadcastHost!
    fileprivate var mListener: ((String, Bool, String, String) -> ())?
    fileprivate var mReceiverId: Int!
    
    // MARK: notify methods
    
    public static func notifyActivitiesLoading(_ host: BroadcastHost, _ identifier: String) {
        notify(host, ACTIVITIES_LOADING, identifier)
    }
    
    public static func notifyActivitiesUpdated(_ host: BroadcastHost) {
        notify(host, ACTIVITIES_UPDATED)
    }
    
    public static func notifyTrackerDataUpdated(_ host: BroadcastHost, identifier: String, subIdentifier: String) {
        notify(host, TRACKER_DATA_UPDATED, identifier, subIdentifier)
    }
    
    public static func notifyApplicationForeground(_ host: BroadcastHost) {
        notify(host, APPLICATION_FOREGROUND)
    }

    fileprivate static func notify(_ host: BroadcastHost, _ broadcastKey: String, _ identifier: String = Constants.EMPTY, _ subIdentifier: String = Constants.EMPTY) {
        var userInfo = [AnyHashable: Any]()
        userInfo[SENDER_ID_KEY] = host.broadcastIdentifier()
        userInfo[IDENTIFIER_KEY] = identifier
        userInfo[IDENTIFIER_SUB_KEY] = subIdentifier
        BroadcastUtils.sendBroadcast(broadcastKey, object: nil, userInfo: userInfo)
    }
    
    // MARK: init methods
    
    public init(_ host: BroadcastHost) {
        mHost = host
        mHost.broadcastRegister(self)
        mReceiverId = mHost.broadcastIdentifier()
    }
    
    public func registerForType(_ type: String, observer: AnyObject? = nil, selector: Selector? = nil) {
        #if DEBUG
            if (observer == nil && selector != nil) || (observer != nil && selector == nil) {
                Logger.e("Bad broadcast registration on \(classNameFor(BaseBroadcast.self))")
            }
        #endif

        BroadcastUtils.registerReceiver(observer ?? self, selector: selector ?? #selector(self.onReceive(_:)), type: type)
    }
    
    public func unregister() {
        BroadcastUtils.unregisterReceiver(self)
    }
    
    @objc func onReceive(_ notification: Notification) {
        let type = notification.name.rawValue
        let senderId = notification.userInfo?[BaseBroadcast.SENDER_ID_KEY] as? Int ?? Constants.INVALID
        let identifier = notification.userInfo?[BaseBroadcast.IDENTIFIER_KEY] as? String ?? Constants.EMPTY
        let subIdentifier = notification.userInfo?[BaseBroadcast.IDENTIFIER_SUB_KEY] as? String ?? Constants.EMPTY
        
        if mListener != nil {
            let sentByMyself = mReceiverId == senderId
            mListener?(type, sentByMyself, identifier, subIdentifier)
        }
    }
    
    public func setListener(_ listener: @escaping (String, Bool, String, String) -> ()) {
        mListener = listener
    }
}
