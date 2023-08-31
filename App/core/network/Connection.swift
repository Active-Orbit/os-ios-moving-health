//
//  Connection.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import UIKit
import Alamofire

/**
 * Class used to make network requests and retrieve response data
 */
public class Connection<T: BaseRequest> {
    
    fileprivate var request: DataRequest?
    
    fileprivate var mController: BaseController?
    public var tag = Constants.INVALID
    
    public var webService: WebService<T>!
    public var listener: ClosureConnection!
    
    public var isOverridden = false
    public var isRunning = false
    
    fileprivate var timeoutExtendedLocal = false
    public func timeoutExtended(_ boolean: Bool) -> Connection {
        timeoutExtendedLocal = boolean
        return self
    }
    
    fileprivate var sessionManager: Session!
    
    // MARK: init methods
    
    public init(_ webService: WebService<T>, _ listener: @escaping ClosureConnection) {
        self.webService = webService
        self.listener = listener
    }
    
    // MARK: starts methods
    
    public func connect() {
        backgroundThread {
            self.initConnection()
        }
    }
    
    fileprivate func initConnection() {
        mainThread {
            self.listener(self.tag, .STARTED, nil)
        }
        
        startConnection({ response in
            if response != nil {
                Logger.i("Connection response [\(self.webService.urlString)]: " + response!)
                mainThread {
                    self.listener(self.tag, .SUCCESS, response)
                }
            } else {
                Logger.w("Connection response [\(self.webService.urlString)] is null")
                mainThread {
                    self.listener(self.tag, .ERROR, nil)
                }
            }
            
            mainThread {
                // always notify completed request
                self.listener(self.tag, .COMPLETED, nil)
                self.isRunning = false
            }
        })
    }
    
    fileprivate func startConnection(_ responseListener: @escaping (String?) -> ()) {
        
        var headers = HTTPHeaders()
        if !TextUtils.isEmpty(webService.contentType) {
            headers[Network.CONTENT_TYPE] = webService.contentType
        }
        if !TextUtils.isEmpty(webService.connection) {
            headers[Network.CONNECTION] = webService.connection
        }
        if !TextUtils.isEmpty(webService.cacheControl) {
            headers[Network.CACHE_CONTROL] = webService.cacheControl
        }
        if !webService.headers.isEmpty {
            for header in webService.headers {
                headers[header.key] = header.value
            }
        }
        
        // configurations
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeoutExtendedLocal ? Network.CONNECTION_TIMEOUT_EXTENDED : Network.CONNECTION_TIMEOUT
        configuration.timeoutIntervalForResource = timeoutExtendedLocal ? Network.SOCKET_TIMEOUT_EXTENDED : Network.SOCKET_TIMEOUT
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        configuration.headers = headers
        sessionManager = Session(configuration: configuration)
        
        isRunning = true
        
        if webService.params != nil {
            request = sessionManager.request(webService.url!, method: webService.method, parameters: webService.params, encoder: JSONParameterEncoder.default, headers: headers, interceptor: nil, requestModifier: nil)
        } else {
            request = sessionManager.request(webService.url!, method: webService.method, parameters: nil, encoding: URLEncoding.default, headers: headers, interceptor: nil, requestModifier: nil)
        }

        request!.responseString(completionHandler: { response in
            guard !self.isOverridden else {
                Logger.w("Connection [\(self.webService.urlString)] has been overridden")
                self.isRunning = false
                return
            }
            
            #if DEBUG
            let paramsString = self.webService.params?.toJson() ?? "null"
            var requestBody = Constants.EMPTY
            if response.request?.httpBody != nil {
                requestBody = String(data: response.request!.httpBody!, encoding: .utf8) ?? Constants.EMPTY
            }
            Logger.d("Connection" +
                "\nUrl: " + self.webService.urlString +
                "\nTimeout: " + (self.timeoutExtendedLocal ? "Extended" : "Normal") +
                "\nParams: " + paramsString +
                "\nRequest: " + requestBody
            )
            #endif
            
            switch response.result {
                case .success(let value):
                    responseListener(value)
                case .failure(let error):
                    Logger.e("Unexpected HTTP response: " + error.localizedDescription)
                    responseListener(nil)
            }
        })
    }
    
    // MARK: utility methods
    
    public func cancel() {
        request?.cancel()
    }
}
