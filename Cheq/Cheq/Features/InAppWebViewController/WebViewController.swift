//
//  WebViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 11/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    let viewModel = WebViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showNavBar()
        self.hideBackTitle()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadUrl()
        activeTimestamp()
    }
    override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
          self.hideNavBar()
    }
    
    func reloadUrl() {
        if viewModel.url.isEmpty == false {
            webView.navigationDelegate = self
            if let url = URL(string: viewModel.url) {
                let req = URLRequest(url: url)
                webView.load(req)
            }
        }
    }
}

extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("webView didStartProvisionalNavigation")
        AppConfig.shared.showSpinner()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("webView didFinish navigation")
        AppConfig.shared.hideSpinner()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("webView didFail navigation")
        AppConfig.shared.hideSpinner()
    }
}
