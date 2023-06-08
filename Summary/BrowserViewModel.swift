//
//  BrowserViewModel.swift
//  Summary
//
//  Created by Eric Kennedy on 6/7/23.
//

import Foundation
import WebKit

class BrowserViewModel: NSObject, ObservableObject, WKNavigationDelegate {
    weak var webView: WKWebView? {
        didSet {
            webView?.navigationDelegate = self
        }
    }
    
    @Published var urlString = "https://developer.apple.com/videos/play/wwdc2023/10149"
    @Published var transcript = ""
    
    // WKWebViewNavigationDelegate
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url,
        let scheme = url.scheme, scheme.contains("http") else {
           // url is a local file or a mailto which we don't support so cancel this request
           decisionHandler(.cancel)
           return
        }
        print("Loading: ", url)
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if urlString.contains("developer.apple.com") {
            webView.evaluateJavaScript("document.querySelector('li.transcript')?.innerText") { (result, error) in
                guard error == nil else {
                    print("Error parsing transcript", String(describing: error))
                    return
                }
                if let resultNSString = result as? NSString { // Cast callback NSString object to a struct (Swift String)
                    self.trimTranscript(resultNSString as String)
                }
            }
        }
    }
    
    func trimTranscript(_ result: String) {
        
        var trimmedString = result
        if let prefixRange = trimmedString.range(of: "Download") {
            trimmedString.removeSubrange(prefixRange)
        }
        if trimmedString.hasPrefix("Array") {
            self.transcript = ""
        } else {
            self.transcript = trimmedString.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        print(self.transcript)
    }
    
    func loadURLString() {
        if let url = URL(string: urlString) {
            webView?.load(URLRequest(url: url))
        }
    }
    
    func reload() {
        webView?.reload()
    }
}

