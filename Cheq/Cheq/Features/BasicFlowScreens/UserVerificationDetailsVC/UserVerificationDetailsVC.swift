//
//  UserVerificationDetailsVC.swift
//  Cheq
//
//  Created by Sachin Amrale on 10/09/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

class UserVerificationDetailsVC: UIViewController {
    
    var viewModel: UserVerificationDetailsViewModel!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var startButton: CNButton!
    @IBOutlet weak var dobView: HeaderLabelView!
    @IBOutlet weak var addressView: HeaderLabelView!
    @IBOutlet weak var nameView: HeaderLabelView!
    @IBOutlet weak var userIDView: UserIDView!
    @IBOutlet weak var checkmarkButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = UserVerificationDetailsViewModel.fromAppData()
        self.setUpUI()
    }
    
    func setUpUI(){
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.startButton.createShadowLayer()
        self.userIDView.layer.cornerRadius = 15
        self.userIDView.clipsToBounds = true
        self.checkmarkButton.setImage(UIImage(named: "unchecked-1"), for: .normal)
        self.checkmarkButton.addTarget(self, action: #selector(checkMarkClicked(sender:)), for: .touchUpInside)
        self.startButton.isEnabled = false
        self.startButton.alpha = 0.3
        
        self.nameView.headerLabel.text = "Name"
        self.nameView.valueLabel.text = viewModel.name
        
        self.dobView.headerLabel.text = "DOB"
        self.dobView.valueLabel.text = viewModel.dob
        
        self.addressView.headerLabel.text = "Current address"
        self.addressView.valueLabel.text = viewModel.address
        
        self.userIDView.idImageView.image = viewModel.docInfo.type.icon
        self.userIDView.headerLabel.text = viewModel.docInfo.type.rawValue
        
        self.showNavBar()
        self.showBackButton()

        if viewModel.docInfo.hasState {
            self.userIDView.idInfoView1.headerLabel.text = "State"
            self.userIDView.idInfoView1.valueLabel.text = viewModel.docInfo.state
            
            self.userIDView.idInfoView2.headerLabel.text = "Number"
            self.userIDView.idInfoView2.valueLabel.text = viewModel.docInfo.number
        } else {
            self.userIDView.idInfoView1.headerLabel.text = "Number"
            self.userIDView.idInfoView1.valueLabel.text = viewModel.docInfo.number
        }
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        let attributes = [NSAttributedString.Key.paragraphStyle : style,
                          NSAttributedString.Key.font : UIFont(name: "SFUIText-Regular", size: 14)!]
        let text = "I consent to the collection, use and disclosure of my personal information in accordance with Cheq Pty Ltd's Privacy Policy, and consent to my personal information being disclosed to a credit reporting agency (for identity verification purposes only and not credit-related) or my information being checked with the document issuer or official record holder via third party systems in connection with a request to verify my identity in accordance with the AML/CTF Act."
        self.textView.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
    
    @objc func checkMarkClicked(sender: UIButton){
        if sender.image(for: .normal) == UIImage(named: "unchecked-1"){
            self.checkmarkButton.setImage(UIImage(named: "checked"), for: .normal)
            self.startButton.isEnabled = true
            self.startButton.alpha = 1.0
        }else{
            self.checkmarkButton.setImage(UIImage(named: "unchecked-1"), for: .normal)
            self.startButton.isEnabled = false
            self.startButton.alpha = 0.3
        }
    }
    
    @IBAction func onStartPressed(_ sender: Any) {
        
        let request = DataHelperUtil.shared.retrieveUserDetailsKYCReq()
        AppConfig.shared.showSpinner()
        
        CheqAPIManager.shared.postUserDetailsFrankieKYC(request: request).done { (success) in
            AppConfig.shared.hideSpinner {}
            if success{
                NotificationUtil.shared.notify(UINotificationEvent.lendingOverview.rawValue, key: "", value: "")
                AppNav.shared.dismissModal(self)
            }else{
                self.showError(CheqAPIManagerError.unableToPerformKYCNow) {
                    NotificationUtil.shared.notify(UINotificationEvent.lendingOverview.rawValue, key: "", value: "")
                    AppNav.shared.dismissModal(self)
                }
            }
        }.catch { err in
            AppConfig.shared.hideSpinner {
                LoggingUtil.shared.cPrint(err.code())
                LoggingUtil.shared.cPrint(err.localizedDescription)
                self.showError(err) { }
            }
        }
        
//        viewModel.onStartVerification()
//            .done { result in
//                // finish verification process
//                AppConfig.shared.hideSpinner {
//                }
//        }.catch { err in
//            AppConfig.shared.hideSpinner {
//                self.showError(CheqAPIManagerError.unableToPerformKYCNow) {
//                }
//            }
//        }
    }
}
