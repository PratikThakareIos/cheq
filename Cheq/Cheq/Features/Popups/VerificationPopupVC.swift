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
    @objc func tappedOnLearnMoreButton()
}

class VerificationPopupVC: UIViewController {
    
    @IBOutlet weak var vwContainer: UIView!

    @IBOutlet weak var lblHeading:UILabel!
    @IBOutlet weak var lblMessage:UILabel!
    @IBOutlet weak var sendButton:CNButton!
    @IBOutlet weak var imgEmoji:UIImageView!
    @IBOutlet weak var viewSecurityImage: UIView!
    
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnLearnMore: UIButton!
    @IBOutlet weak var popViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var snoozeDateView: UIView!
    
    @IBOutlet weak var securityImageStackView: UIStackView!
    
    @IBOutlet weak var snoozeOldDate: UILabel!
    
    @IBOutlet weak var snoozeNewDate: UILabel!
    
    var delegate:VerificationPopupVCDelegate?
    
    var emojiImage = UIImage()
    var heading = ""
    var message = ""
    var attributedMessage : NSMutableAttributedString = NSMutableAttributedString.init(string: "")
    var showSendButton = false
    var buttonTitle = ""
    var buttonCloseTitle = ""
    var isShowViewSecurityImage = false
    var isChangeLineHight = false
    var isShowLearnMoreButton = false
    var isShowCloseButton = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    private func setupUI(){
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        vwContainer.addGestureRecognizer(tap)
        vwContainer.isUserInteractionEnabled = true
                
        self.lblHeading.text = heading
        
        if attributedMessage.length > 0 {
             self.lblMessage.attributedText = attributedMessage
        }else{
             self.lblMessage.text = message
        }
        
        if isChangeLineHight {
          self.lblMessage.setLineSpacing(lineSpacing: 8.0)
        }
        
        self.btnLearnMore.isHidden = !isShowLearnMoreButton
        self.sendButton.isHidden = !showSendButton
        self.btnClose.isHidden = !isShowCloseButton
        
        self.imgEmoji.image = emojiImage
        self.viewSecurityImage.isHidden = !isShowViewSecurityImage
        
        self.sendButton.setTitle(buttonTitle, for: .normal)
        if buttonCloseTitle != "" {
            self.btnClose.setTitle(buttonCloseTitle, for: .normal)
        }else{
            self.btnClose.setTitle("Close", for: .normal)
        }
        self.sendButton.createShadowLayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupUI()
        self.showPopup()
    }
    
    // function which is triggered when handleTap is called
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
         self.hidePopup()
         self.delegate?.tappedOnCloseButton()
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
               self.dismiss(animated: false, completion: nil)
         }
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
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func sendButtonAction(){
        self.hidePopup()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.dismiss(animated: false, completion: {
                self.delegate?.tappedOnSendButton()
            })
        }
    }
    
    @IBAction func btnLearnMoreAction(){
          self.hidePopup()
          self.delegate?.tappedOnLearnMoreButton()
          DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
              self.dismiss(animated: false, completion: nil)
          }
    }
}
