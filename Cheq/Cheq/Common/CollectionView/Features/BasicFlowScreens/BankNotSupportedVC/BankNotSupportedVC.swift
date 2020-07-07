//
//  BankNotSupportedVC.swift
//  Cheq
//
//  Created by Amit.Rawal on 11/05/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

//GetUserActionResponse(userAction: Optional(Cheq.GetUserActionResponse.UserAction.bankNotSupported), title: Optional(\"We no longer support your bank\"), detail: Optional(\"Due to recent changes we are no longer able to support your bank.\"), linkedInstitutionId: nil, canSelectBank: Optional(false), showClose: Optional(false), showReconnect: Optional(false), showChatWithUs: Optional(true), actionRequiredGuidelines: nil, link: nil)"]

class BankNotSupportedVC: UIViewController {
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    
    @IBOutlet weak var btnChatWithUs: UIButton!
    @IBOutlet weak var btnTryAgain: UIButton!
    

    var getUserActionResponse: GetUserActionResponse?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let getUserActionResponse = getUserActionResponse, getUserActionResponse.userAction == GetUserActionResponse.UserAction.actionRequiredByBank else{
            self.dismiss(animated: true, completion: nil)
            return
         }
        self.setupUI(getUserActionResponse)
        //showNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.btnChatWithUs.layer.cornerRadius = 27
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupKeyboardHandling()
        activeTimestamp()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeObservables()
    }

    func setupUI(_ res : GetUserActionResponse) {
        
        self.btnChatWithUs.layer.cornerRadius = 27
        self.btnChatWithUs.layer.masksToBounds = true
            
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        //iconImage.image = viewModel.image
        //confirmButton.setTitle(viewModel.confirmButtonTitle, for: .normal)
                
        viewTitle.text = res.title ?? ""
        viewTitle.textColor =  UIColor.white
        //viewTitle.font = AppConfig.shared.activeTheme.headerBoldFont
        
        lblDetail.text = res.detail ?? ""
        
        if let canSelectBank = res.canSelectBank, canSelectBank == true {
            
        }else{
            
        }
        
        if let showClose = res.showClose, showClose == true {
            showCloseButton()
        }else{
            
        }
        
        if let showReconnect = res.showReconnect, showReconnect == true {
            btnTryAgain.isHidden = false
        }else{
            btnTryAgain.isHidden = true
        }
        
        if let showChatWithUs = res.showChatWithUs, showChatWithUs == true {
            self.btnChatWithUs.isHidden = false
        }else{
            self.btnChatWithUs.isHidden = true
        }
        
        if let link = res.link {
                       
        }else{
                       
        }
    }

    @IBAction func btnChatWithUsAction(_ sender: Any) {
        IntercomManager.shared.loginIntercom().done { authUser in
            IntercomManager.shared.present(str_cErrorStep : "BankNotSupported")
            }.catch { err in
                self.showError(err, completion: nil)
        }
    }
    
    @IBAction func btnTryAgainAction(_ sender: Any) {
        
    }
        
}

