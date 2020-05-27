//
//  UserActionRequiredVC.swift
//  Cheq
//
//  Created by Amit.Rawal on 08/05/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit
import PromiseKit
import FRHyperLabel


//GetUserActionResponse(userAction: Optional(Cheq.GetUserActionResponse.UserAction.actionRequiredByBank), title: Optional(\"User action required\"), detail: Optional(\"We have having problems connecting to your bank. Please follow these directions to resolve the issues\"), linkedInstitutionId: nil, canSelectBank: Optional(false), showClose: Optional(false), showReconnect: Optional(true), showChatWithUs: Optional(true), actionRequiredGuidelines: Optional([\"Login to your Internet banking through your computer\", \"Please make sure you are able to navigate to your accounts\", \"Come back and try connecting to your bank again\"]), link: nil)"]

class UserActionRequiredVC: UIViewController {
 
    @IBOutlet weak var viewTitle: CLabel!
    @IBOutlet weak var lblVerificationInstructions: UILabel!

    @IBOutlet weak var confirmButton: CNButton!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var lblInfo1: UILabel!
    @IBOutlet weak var lblInfo2: UILabel!
    @IBOutlet weak var lblInfo3: UILabel!
    
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
//         super.viewWillAppear(animated)
//          guard let getUserActionResponse = getUserActionResponse, getUserActionResponse.userAction == GetUserActionResponse.UserAction.actionRequiredByBank else{
//                 self.dismiss(animated: true, completion: nil)
//                 return
//         }
//        self.setupUI(getUserActionResponse)
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
        
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.confirmButton.createShadowLayer()
        //iconImage.image = viewModel.image
        //confirmButton.setTitle(viewModel.confirmButtonTitle, for: .normal)
                
        viewTitle.text = res.title ?? ""
        viewTitle.font = AppConfig.shared.activeTheme.headerBoldFont
        
        lblVerificationInstructions.text = res.detail ?? ""
        
        if let canSelectBank = res.canSelectBank, canSelectBank == true {
            
        }else{
            
        }
        
        if let showClose = res.showClose, showClose == true {
                showCloseButton()
        }else{
                
        }
        
        
        if let showReconnect = res.showReconnect, showReconnect == true {
                       
        }else{
                       
        }
        
        if let showChatWithUs = res.showChatWithUs, showChatWithUs == true {
                       
        }else{
                       
        }
        
        if let arrActionRequiredGuidelines = res.actionRequiredGuidelines, arrActionRequiredGuidelines.count > 2 {
           
            lblInfo1.text = arrActionRequiredGuidelines[0]
            lblInfo2.text = arrActionRequiredGuidelines[1]
            lblInfo3.text = arrActionRequiredGuidelines[2]
        
        }else{
            lblInfo1.text = ""
            lblInfo2.text = ""
            lblInfo3.text = ""
        }

        if let link = res.link {
                       
        }else{
                       
        }

        //GetUserActionResponse(userAction: Optional(Cheq.GetUserActionResponse.UserAction.actionRequiredByBank), title: Optional(\"User action required\"), detail: Optional(\"We have having problems connecting to your bank. Please follow these directions to resolve the issues\"), linkedInstitutionId: nil, canSelectBank: Optional(false), showClose: Optional(false), showReconnect: Optional(true), showChatWithUs: Optional(true), actionRequiredGuidelines: Optional([\"Login to your Internet banking through your computer\", \"Please make sure you are able to navigate to your accounts\", \"Come back and try connecting to your bank again\"]), link: nil)"]

    }

    @IBAction func btnChatWithUsAction(_ sender: Any) {
        IntercomManager.shared.loginIntercom().done { authUser in
            IntercomManager.shared.present(str_cErrorStep : "ActionRequiredByBank")
            }.catch { err in
                self.showError(err, completion: nil)
        }
    }
    
    @IBAction func btnConnectAction(_ sender: Any) {
        // NotificationUtil.shared.notify(UINotificationEvent.reconnectToBank.rawValue, key: "", object: "")
        //self.dismiss(animated: true, completion: nil)
        self.refreshTokenAndReconnectToBankLinking()
    }
    
    func refreshTokenAndReconnectToBankLinking(){
            
    //        UserAction: ActionRequiredByBank
    //        * show the screen and guideline. show the "Reconnect" button,
    //        * call the backend API: PUT v1/connections/refresh
    //        * then calling job status.
            
            
            print("refreshTokenAndReconnectToBankLinking called")

            AppConfig.shared.showSpinner()
            CheqAPIManager.shared.getJobIdAfterRefreshConnection().done { getRefreshConnectionResponse in
                AppConfig.shared.hideSpinner {
                       if let connectingToBank = AppNav.shared.initViewController(StoryboardName.common.rawValue, storyboardId: CommonStoryboardId.connecting.rawValue, embedInNav: false) as? ConnectingToBankViewController {
                           connectingToBank.modalPresentationStyle = .fullScreen
                           AppData.shared.bankJobId = getRefreshConnectionResponse.jobId
                           connectingToBank.jobId = AppData.shared.bankJobId
                           self.present(connectingToBank, animated: true, completion: nil)
                       }
                }
            }.catch { [weak self] err in
                guard let self = self else { return }
                AppConfig.shared.hideSpinner {
                     self.showError(err, completion: nil)
                   //  let connectingFailed =  AppNav.shared.initViewController(StoryboardName.common.rawValue, storyboardId: CommonStoryboardId.reTryConnecting.rawValue, embedInNav: false)
                   //  connectingFailed.modalPresentationStyle = .fullScreen
                   //  self.present(connectingFailed, animated: true)
                }
            }
      }

}

