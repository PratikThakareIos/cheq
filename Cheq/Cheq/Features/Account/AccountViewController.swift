//
//  AccountViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 4/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class AccountViewController: CTableViewController {
    
    @IBOutlet weak var viewFooterBottom: UIView!
    @IBOutlet weak var lblVersion: UILabel!
    
    override func registerCells() {
        let cellModels: [TableViewCellViewModelProtocol] = [SpacerTableViewCellViewModel(), BottomTableViewCellViewModel(), TopTableViewCellViewModel(), AvatarTableViewCellViewModel(), AccountInfoTableViewCellViewModel(), LinkTableViewCellViewModel(), InfoNoteTableViewCellViewModel()]
        for vm: TableViewCellViewModelProtocol in cellModels {
            let nib = UINib(nibName: vm.identifier, bundle: nil)
            self.tableView.register(nib, forCellReuseIdentifier: vm.identifier)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = AccountViewModel()
    
        self.setupUI()
        setupDelegate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activeTimestamp()
        registerObservables()
        if let vm = self.viewModel as? AccountViewModel, vm.sections.count == 0 {
            NotificationUtil.shared.notify(UINotificationEvent.accountInfo.rawValue, key: "", value: "")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavBar()
        hideBackTitle()
        
         AppConfig.shared.addEventToFirebase(PassModuleScreen.Profile.rawValue, FirebaseEventKey.profile_home.rawValue ,FirebaseEventKey.profile_home.rawValue, FirebaseEventContentType.screen.rawValue)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeObservables()
    }
    
    func setupUI() {
        let ver = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        lblVersion.text = "Version \(ver)"
        lblVersion.font = AppConfig.shared.activeTheme.defaultFont
        lblVersion.textColor = AppConfig.shared.activeTheme.lightGrayColor
        
        hideNavBar()
        hideBackTitle()
 
        self.title = "" //ScreenName.accountInfo.rawValue
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.tableView.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        
        tableView.tableFooterView = viewFooterBottom
        tableView.setContentOffset(CGPoint(x: 0, y: tableView.contentSize.height), animated: false)
    }
    
    func registerObservables() {
        //setupKeyboardHandling()
        NotificationCenter.default.addObserver(self, selector: #selector(accountInfo(_:)), name: NSNotification.Name(UINotificationEvent.accountInfo.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable(_:)), name: NSNotification.Name(UINotificationEvent.reloadTable.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openWebLink(_:)), name: NSNotification.Name(UINotificationEvent.openLink.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.intercom(_:)), name: NSNotification.Name(UINotificationEvent.intercom.rawValue), object: nil)
    }
    
}

//MARK: notification handlers
extension AccountViewController {
    
    /// if we get notification to open **link**, it is not always just for real web links, there are instances where we use a **link** UI to trigger opening of App setting, trigger logout and any other actions if needed.
    @objc func openWebLink(_ notification: NSNotification) {
        
        guard let link = notification.userInfo?[NotificationUserInfoKey.link.rawValue] as? String else { return }
        LoggingUtil.shared.cPrint("open link,\(link)")
        // check if it's log out, we treat it differently
        if link == links.logout.rawValue {
            self.openLogOutPopup()
            return
        }
        
        if link == links.appSetting.rawValue {
            AppNav.shared.pushToAppSetting()
            return
        }
        
        //        if link == links.helpAndSupport.rawValue {
        //            NotificationUtil.shared.notify(UINotificationEvent.intercom.rawValue, key: "", value: "")
        //            return
        //        }
        
        
        
        
        guard let url = URL(string: link) else { return }
        
        if link == "https://cheq.com.au/terms"{
            AppConfig.shared.addEventToFirebase(PassModuleScreen.Profile.rawValue, FirebaseEventKey.profile_help_tc.rawValue, FirebaseEventKey.profile_help_tc.rawValue, FirebaseEventContentType.button.rawValue)
        }else{
            AppConfig.shared.addEventToFirebase(PassModuleScreen.Profile.rawValue, FirebaseEventKey.profile_help_privacy.rawValue, FirebaseEventKey.profile_help_privacy.rawValue, FirebaseEventContentType.button.rawValue)
        }
        
        AppNav.shared.pushToInAppWeb(url, viewController: self)
    }
    
    @objc func accountInfo(_ notification: NSNotification) {
        // let vm = self.viewModel as! AccountViewModel
        // vm.render()
        
        if let vm = self.viewModel as? AccountViewModel {
             vm.render()
        }
    }
}

//MARK: - Verification popup
extension AccountViewController: VerificationPopupVCDelegate{
    
    func openLogOutPopup(){
        self.view.endEditing(true)
        let storyboard = UIStoryboard(name: StoryboardName.Popup.rawValue, bundle: Bundle.main)
        if let popupVC = storyboard.instantiateInitialViewController() as? VerificationPopupVC {
            popupVC.delegate = self
            popupVC.heading = "Are you sure you want to log out?"
            popupVC.message = ""
            popupVC.buttonTitle = "Log out"
            popupVC.buttonCloseTitle = "Cancel"
            popupVC.showSendButton = true
            popupVC.emojiImage = UIImage(named: "image-moreInfo") ?? UIImage()

            //self.present(popupVC, animated: false, completion: nil)
            self.tabBarController?.present(popupVC, animated: false, completion: nil)
        }
    }
    
    func tappedOnSendButton(){
        self.logout()
    }
    
    func tappedOnCloseButton(){
        
    }
    
    func tappedOnLearnMoreButton(){
        
    }
}
