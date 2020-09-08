//
//  CategorisationInProgressVC.swift
//  Cheq
//
//  Created by Amit.Rawal on 14/05/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

// ["\n>> userActionResponse = GetUserActionResponse(userAction: Optional(Cheq.GetUserActionResponse.UserAction.categorisationInProgress), title: Optional(\"We are syncing your bank transactions\"), detail: Optional(\"You will be notified once we have synced your transactions. This could take up to 30 min.\"), linkedInstitutionId: nil, canSelectBank: Optional(false), showClose: Optional(false), showReconnect: Optional(false), showChatWithUs: Optional(true), actionRequiredGuidelines: nil, link: nil)"]

class CategorisationInProgressVC: UIViewController {
    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var viewTitle: UILabel!
    @IBOutlet var lblDetail: UILabel!

    @IBOutlet var btnChatWithUs: UIButton!
    @IBOutlet var btnTryAgain: UIButton!

    var getUserActionResponse: GetUserActionResponse?
    var timer : Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let getUserActionResponse = getUserActionResponse, getUserActionResponse.userAction == .categorisationInProgress else {
            dismiss(animated: true, completion: nil)
            return
        }
        setupUI(getUserActionResponse)
        scheduledTimerWithTimeInterval()
        // showNavBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        btnChatWithUs.layer.cornerRadius = 27
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // setupKeyboardHandling()
        activeTimestamp()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeObservables()
    }

    // to set time interval of 15 seconds to call user actions API
    func scheduledTimerWithTimeInterval() {
        if timer == nil{
            timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(getUserAction), userInfo: nil, repeats: true)
        }
    }

    func setupUI(_ res: GetUserActionResponse) {
        btnChatWithUs.layer.cornerRadius = 27
        btnChatWithUs.layer.masksToBounds = true

        view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        // iconImage.image = viewModel.image
        // confirmButton.setTitle(viewModel.confirmButtonTitle, for: .normal)

        viewTitle.text = res.title ?? ""
        // viewTitle.textColor =  UIColor.white
        // viewTitle.font = AppConfig.shared.activeTheme.headerBoldFont

        lblDetail.text = res.detail ?? ""

        if let canSelectBank = res.canSelectBank, canSelectBank == true {
        } else {
        }

        if let showClose = res.showClose, showClose == true {
            showCloseButton()
        } else {
        }

        if let showReconnect = res.showReconnect, showReconnect == true {
            btnTryAgain.isHidden = false
        } else {
            btnTryAgain.isHidden = true
        }

        if let showChatWithUs = res.showChatWithUs, showChatWithUs == true {
            btnChatWithUs.isHidden = false
        } else {
            btnChatWithUs.isHidden = true
        }

        if let link = res.link {
        } else {
        }
    }

    @IBAction func btnChatWithUsAction(_ sender: Any) {
        IntercomManager.shared.loginIntercom().done { _ in
            IntercomManager.shared.present(str_cErrorStep: "CategorisationInProgress")
        }.catch { err in
            self.showError(err, completion: nil)
        }
    }

    @IBAction func btnTryAgainAction(_ sender: Any) {
    }

    // MARK: Get User Actions

    @objc func getUserAction() {
        CheqAPIManager.shared.getUserActions().done { userActionResponse in
            switch userActionResponse.userAction {
            case .genericInfo:
                break
            case .categorisationInProgress:
                break
            case ._none:
                LoggingUtil.shared.cPrint("go to home screen")
                // Load to dashboard
                AppData.shared.isOnboarding = false
                AppData.shared.migratingToNewDevice = false
                AppData.shared.completingDetailsForLending = false
                self.navigateToDashboard()
                break
            case .actionRequiredByBank:
                break
            case .bankNotSupported:
                break
            case .invalidCredentials:
                break
            case .missingAccount:
                break
            case .requireMigration, .requireBankLinking, .accountReactivation, .bankLinkingUnsuccessful:
                break
            case .none:
                LoggingUtil.shared.cPrint("err")
            }
        }
    }
    
    func navigateToDashboard(){
        DispatchQueue.main.async {
            self.view.endEditing(true)
            self.timer?.invalidate()
            // go to dashboard board
            var vcInfo = [String: String]()
            vcInfo[NotificationUserInfoKey.storyboardName.rawValue] = StoryboardName.main.rawValue
            vcInfo[NotificationUserInfoKey.storyboardId.rawValue] = MainStoryboardId.tab.rawValue
            NotificationUtil.shared.notify(UINotificationEvent.switchRoot.rawValue, key: NotificationUserInfoKey.vcInfo.rawValue, object: vcInfo)
        }
    }
}
