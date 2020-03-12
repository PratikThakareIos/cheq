//
//  AgreementItemTableViewCell.swift
//  Cheq
//
//  Created by Xuwei Liang on 14/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import WebKit
/**
 AgreementItemTableViewCell is used for displaying agreement items
 */
class AgreementItemTableViewCell: CTableViewCell {

    /// refer to **xib** layout->WebView
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var webViewHeight: NSLayoutConstraint!
    
     /// refer to **xib** layout->Submit Button
    @IBOutlet weak var submitButton: UIButton!
    
    /// refer to **xib** layout
    @IBOutlet weak var agreementTitle: CLabel!
    
    /// refer to **xib** layout
    
    /// refer to **xib** layout
    @IBOutlet weak var readMore: UIButton!
    
    /// refer to **xib** layout
    @IBOutlet weak var containerView: UIView!
    
    /// called when init from **xib**
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewModel = AgreementItemTableViewCellViewModel()
        setupConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    /// called **setupConfig** whenever we want to have updated UI
    override func setupConfig() {
        self.backgroundColor = .clear
        let vm = self.viewModel as! AgreementItemTableViewCellViewModel
        self.agreementTitle.text = vm.title
        self.agreementTitle.font = AppConfig.shared.activeTheme.mediumFont
   
      // html content
        self.webView.loadHTMLString(vm.message, baseURL: nil)
        self.webViewHeight.constant = vm.message != "" ? 185:0
        self.webView.scrollView.isScrollEnabled = false
        
        
        //Submit Button
        self.submitButton.isHidden = true
        
        if vm.expanded {
           // self.readMore.setTitle(vm.readLessTitle, for: .normal)
        } else {
            self.readMore.setTitle(vm.readMoreTitle, for: .normal)
        }
        self.readMore.setTitleColor(AppConfig.shared.activeTheme.linksColor, for: .normal)
        self.readMore.titleLabel?.font = AppConfig.shared.activeTheme.defaultFont
        AppConfig.shared.activeTheme.cardStyling(self.containerView, borderColor: AppConfig.shared.activeTheme.lightGrayBorderColor)
    }
    
    /// action called when the **readMore** button is pressed for expand/compress
    @IBAction func readMore(_ sender: Any) {
        LoggingUtil.shared.cPrint("Read more")
        
        let vm = self.viewModel as! AgreementItemTableViewCellViewModel
//        if vm.expanded == false {
//            vm.expanded = true
//
////          //  let sizeThatFits = self.agreementContent.sizeThatFits(CGSize(width: self.agreementContent.frame.width, height: CGFloat(MAXFLOAT)))
////            self.webView.scrollView.isScrollEnabled = true
////            self.webViewHeight.constant =  vm.message != "" ? 8200 : 0
////            let scrollPoint = CGPoint(x: 0, y: webView.scrollView.contentSize.height - webView.frame.size.height)
////
////
////            webView.scrollView.setContentOffset(scrollPoint, animated: true)//Set false if you doesn't want animation
////            self.readMore.setTitle(vm.readLessTitle, for: .normal)
////            self.submitButton.isHidden =  vm.message != "" ? false : true
//
//        } else {
//            vm.expanded = false
            self.webView.scrollView.isScrollEnabled = false
            self.webViewHeight.constant = vm.message != "" ? 185:0
            self.readMore.setTitle(vm.readMoreTitle, for: .normal)
            self.submitButton.isHidden = true

//        }
        self.setNeedsLayout()

        NotificationUtil.shared.notify(UINotificationEvent.openLink.rawValue, key: NotificationUserInfoKey.link.rawValue, value: vm.message)
        /// send a notification for table view to reload
        NotificationUtil.shared.notify(UINotificationEvent.reloadTableLayout.rawValue, key: NotificationUserInfoKey.cell.rawValue, object: self)
    }
    
    @IBAction func submitClicked(_ sender: Any) {
        let vm = self.viewModel as! AgreementItemTableViewCellViewModel
         vm.expanded = false
         self.webViewHeight.constant = vm.message != "" ? 185:0
         self.setNeedsLayout()
        
        NotificationUtil.shared.notify(UINotificationEvent.agreemntAccepted.rawValue, key: "", value: "")
        
        NotificationUtil.shared.notify(UINotificationEvent.reloadTableLayout.rawValue, key: NotificationUserInfoKey.cell.rawValue, object: self)
        
    }
    
}
