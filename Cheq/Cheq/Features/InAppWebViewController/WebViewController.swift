//
//  WebViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 11/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import WebKit

protocol WebViewControllerProtocol {
    func dismissViewController(loanActivity: LoanActivity?)
}


class WebViewController: UIViewController {
    
    var delegate: WebViewControllerProtocol?
    
    @IBOutlet weak var webView: WKWebView!
    let viewModel = WebViewModel()
    
    @IBOutlet weak var vwClose: UIView!
    @IBOutlet weak var btnClose: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showNavBar()
        self.hideBackTitle()
        self.vwClose.isHidden = true
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
        
//        var isLoadHTML : Bool = true
//        var message: String = ""
        
        self.webView.navigationDelegate = self
        
        if viewModel.isLoadHTML {
            self.vwClose.isHidden = false
            self.webView.loadHTMLString(viewModel.message, baseURL: nil)
            return
        }
        
        if viewModel.url.isEmpty == false {
            if let url = URL(string: viewModel.url) {
                let req = URLRequest(url: url)
                webView.load(req)
            }
        }
        
    }
    
    @IBAction func btnCloseAction(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            self.delegate?.dismissViewController(loanActivity: self.viewModel.loanActivity)
        })
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
