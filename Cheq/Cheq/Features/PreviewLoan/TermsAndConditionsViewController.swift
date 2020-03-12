//
//  TermsAndConditionsViewController.swift
//  Cheq
//
//  Created by iTelaSoft-PC on 2/25/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit
import WebKit

class TermsAndConditionsViewController: UIViewController {
    var url : String?
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.loadHTMLString(url ?? "", baseURL: nil)
        print(webView.scrollView.contentSize.height)
         let scrollPoint = CGPoint(x: 0, y:7000)
         webView.scrollView.setContentOffset(scrollPoint, animated: true)
    }
    
    @IBAction func acceptedBtnClick(_ sender: Any) {
        
        AppNav.shared.dismiss(self)
        NotificationUtil.shared.notify(UINotificationEvent.agreemntAccepted.rawValue, key: "", value: "")
        
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == webView {
            print("Scrolled")
        }
    }

}
