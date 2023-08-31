//
//  WebService.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation
import Alamofire

/**
 * Class used to build a web service with url and params
 */
public class WebService<T : BaseRequest> {
    
    fileprivate var baseUrl = Preferences.backend.baseUrl
    
    public var method = HTTPMethod.get
    public var encoding: Alamofire.ParameterEncoding = JSONEncoding.default
    public var urlString = Constants.EMPTY
    
    public var contentType = Network.CONTENT_TYPE_APPLICATION_JSON
    public var connection = Network.KEEP_ALIVE
    public var cacheControl = Network.NO_CACHE
    
    public var headers = [String : String]()
    
    public var api: Api
    public var params: T?
    
    /**
     * Return the URL object that represent the WebService
     */
    public var url: URL? {
        get {
            return URL(string: urlString)
        }
    }
    
    convenience init(_ url: String, _ params: T? = nil) {
        self.init(.EMPTY, params)
        urlString = url
    }
    
    init(_ api: Api, _ params: T? = nil) {
        self.api = api
        self.params = params
        self.urlString = "\(baseUrl)/\(api.getUrl())"
    }
}
