//
//  VerificationPopupVC.swift
//  TwitterLoginDemo
//
//  Created by akash.jaiswal on 11/03/20.
//  Copyright © 2020 akash.jaiswal. All rights reserved.
//

import UIKit

@objc protocol VerificationPopupVCDelegate {
    @objc func tappedOnSendButton()
    @objc func tappedOnCloseButton()
}

class VerificationPopupVC: UIViewController {

    @IBOutlet weak var lblHeading:UILabel!
    @IBOutlet weak var lblMessage:UILabel!
    @IBOutlet weak var sendButton:CNButton!
    @IBOutlet weak var imgEmoji:UIImageView!
    @IBOutlet weak var viewSecurityImage: UIView!
    
    @IBOutlet weak var popViewBottom: NSLayoutConstraint!
    
    var delegate:VerificationPopupVCDelegate?
    
    var emojiImage = UIImage()
    var heading = ""
    var message = ""
    var attributedMessage : NSMutableAttributedString = NSMutableAttributedString.init(string: "")
    var showSendButton = false
    var buttonTitle = ""
    var isShowViewSecurityImage = false
    var isChangeLineHight = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI(){
        self.lblHeading.text = heading
        
        if attributedMessage.length > 0 {
             self.lblMessage.attributedText = attributedMessage
        }else{
             self.lblMessage.text = message
        }
        
        if isChangeLineHight {
          self.lblMessage.setLineSpacing(lineSpacing: 8.0)
        }
        
        
       
        self.sendButton.isHidden = !showSendButton
        self.imgEmoji.image = emojiImage
        self.viewSecurityImage.isHidden = !isShowViewSecurityImage
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.sendButton.setTitle(buttonTitle, for: .normal)
        self.sendButton.createShadowLayer()
        self.showPopup()
    }
    
    private func showPopup(){
        popViewBottom.constant = 20
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func hidePopup(){
        popViewBottom.constant = -800
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
}

private extension VerificationPopupVC{
    
    @IBAction func close(){
        self.hidePopup()
        self.delegate?.tappedOnCloseButton()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.25) {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func sendButtonAction(){
        self.hidePopup()
        self.delegate?.tappedOnSendButton()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.25) {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
}
