//
//  File.swift
//  Cheq
//
//  Created by Amit.Rawal on 28/05/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit


//["\n>> userActionResponse = GetUserActionResponse(userAction: Optional(Cheq_DEV.GetUserActionResponse.UserAction.genericInfo), title: Optional(\"Cannot connect to your bank\"), detail: Optional(\"We encountered a problem connecting to your bank. This could be due to your bank website being under maintenance. Please come back in a few hours\"), linkedInstitutionId: nil, canSelectBank: Optional(false), showClose: Optional(false), showReconnect: Optional(false), showChatWithUs: Optional(true), actionRequiredGuidelines: nil, link: nil)"]
//2020-05-28


class GenericInfoVC : UIViewController {
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    
    @IBOutlet weak var btnChatWithUs: UIButton!
    @IBOutlet weak var btnTryAgain: UIButton!
    
    var getUserActionResponse: GetUserActionResponse?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let getUserActionResponse = getUserActionResponse, getUserActionResponse.userAction == .genericInfo else{
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
        //setupKeyboardHandling()
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
        //viewTitle.textColor =  UIColor.white
        //viewTitle.font = AppConfig.shared.activeTheme.headerBoldFont
                
        viewTitle.text = res.title ?? ""
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
            IntercomManager.shared.present(str_cErrorStep : "CategorisationInProgress")
          }.catch { err in
                self.showError(err, completion: nil)
        }
    }
    
    @IBAction func btnTryAgainAction(_ sender: Any) {
        
    }
        
}

