//
//  BrowserView.swift
//  Summary
//
//  Created by Eric Kennedy on 6/7/23.
//

import SwiftUI
import WebKit

struct BrowserView: UIViewRepresentable {
 
    let url: URL

    @ObservedObject var viewModel: BrowserViewModel // for @Published updates to urlString and transcript
    
    func makeUIView(context: Context) -> WKWebView {
        
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        
        let webView = WKWebView(frame: .zero, configuration: configuration)

        // Give the viewModel a reference to this webView so it can change the URL
        viewModel.webView = webView // viewModel.webView.didSet will make the viewModel the webView?.navigationDelegate
        
        webView.load(URLRequest(url: url))
        return webView
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        // Leave empty so it only changes when BrowserViewModel changes the URL
    }
}

