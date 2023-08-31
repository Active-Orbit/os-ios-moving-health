//
//  WebViewController.swift
//  App
//
//  Created by Omar Brugna on 04/11/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import UIKit
import WebKit

public class WebViewController: BaseController {
    
    @IBOutlet weak var toolbar: Toolbar!
    @IBOutlet weak var webView: WKWebView!
    
    fileprivate var myContext = 0
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar()
        
        toolbar.setup(self)
        toolbar.showBackButton()
        
        #if DEBUG
        if TextUtils.isEmpty(controllerBoundle.getString(Extra.WEBVIEW_URL.key)) {
            Exception("Missing webview url on \(className)")
        }
        if TextUtils.isEmpty(controllerBoundle.getString(Extra.WEBVIEW_TITLE.key)) {
            Exception("Missing webview title on \(className)")
        }
        #endif
        
        toolbar.setTitle(controllerBoundle.getString(Extra.WEBVIEW_TITLE.key))
        
        setupWebView()
        
        let url = URL(string: controllerBoundle.getString(Extra.WEBVIEW_URL.key)!)
        webView.load(URLRequest(url: url!))
        
        showProgressView()
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: &myContext)
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            if webView.estimatedProgress == 1.0 {
                hideProgressView()
            }
        }
    }
    
    fileprivate func setupWebView() {
        webView.navigationDelegate = self
        webView.backgroundColor = ColorProvider.get("colorBackground")
        
        // avoid caching
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
    }
}

extension URL {
    
    func valueOf(_ paramaterName: String) -> String? {
        guard let url = URLComponents(string: absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == paramaterName })?.value
    }
}

extension WebViewController: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        if url != nil {  Logger.d("Loading url \(url!.absoluteString)") }
        decisionHandler(.allow)
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.body.innerHTML", completionHandler: { (value: Any!, error: Error!) -> Void in
            if error != nil {
                Logger.w("Error reading webview content \(error.localizedDescription)")
                return
            }
            if value is String {
                let result = value as! String
                Logger.d("Webview content \(result)")
            } else {
                Logger.w("Error reading webview value")
            }
        })
    }
}
