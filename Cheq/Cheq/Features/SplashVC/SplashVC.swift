//
//  SplashVC.swift
//  Cheq
//
//  Created by Amit.Rawal on 06/07/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit
import PromiseKit

class SplashVC: UIViewController {
    
    @IBOutlet weak var loaderImageVw: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        self.startSpinning()
        self.addNotifications()
        self.checkRemoteConfigStatus()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopSpinning()
    }
}

//MARK: -  Notification
extension SplashVC {
    
    func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground(_:))
            , name: NSNotification.Name(rawValue: UIApplication.willEnterForegroundNotification.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.goto_MaintenanceVC(_:)), name: NSNotification.Name(UINotificationEvent.showMaintenanceVC.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.goto_UpdateAppVC(_:)), name: NSNotification.Name(UINotificationEvent.showUpdateAppVC.rawValue), object: nil)
    }
    
    @objc func applicationWillEnterForeground(_ notification: NSNotification){
        LoggingUtil.shared.cPrint("SplashVC_applicationWillEnterForeground")
        self.stopSpinning()
        self.startSpinning()
    }
}

//MARK: -  Remote config status Action
extension SplashVC {
    
     @objc func goto_MaintenanceVC(_ notification: NSNotification){
        self.view.endEditing(true)
        AppNav.shared.presentViewController(StoryboardName.common.rawValue, storyboardId: CommonStoryboardId.maintenanceVC.rawValue, viewController: self, embedInNav: false, animated: false)
    }
    
     @objc func goto_UpdateAppVC(_ notification: NSNotification){
        self.view.endEditing(true)
        AppNav.shared.presentViewController(StoryboardName.common.rawValue, storyboardId: CommonStoryboardId.updateAppVC.rawValue, viewController: self, embedInNav: false, animated: false)
    }
}


//MARK: -  Animation
extension SplashVC {
    
    func startSpinning() {
        //loaderImageVw.image = UIImage(named:"sync-spinning")
        loaderImageVw.startRotating()
    }
    
    func stopSpinning() {
        loaderImageVw.stopRotating()
        //loaderImageVw.image = UIImage(named:"sync-not-spinning")
    }
}


//MARK: -  Animation
extension SplashVC {
    
    func checkRemoteConfigStatus(){
        
        RemoteConfigManager.shared.getApplicationStatusFromRemoteConfig().done { isShowScreenForRemoteConfig in
            if isShowScreenForRemoteConfig {
                //do nothing - notification already fired to show screens - MaintenanceVC or UpdateAppVC
                LoggingUtil.shared.cPrint("do nothing - notification already fired to show screens")
            }else{
                //check further conditions
                LoggingUtil.shared.cPrint("check further conditions")
                self.callLoginAction()
            }
        }.catch { err in
            LoggingUtil.shared.cPrint(err)
            self.callLoginAction()
        }
    }
     
    func callLoginAction() {
        
        let email = UserDefaults.standard.value(forKey: UserDefaultKeys.emailID) as? String ?? ""  //"way@g.com"
        let password = UserDefaults.standard.value(forKey: UserDefaultKeys.password)  as? String ?? "" //"Tfc@12345"
        
        AppData.shared.oneSignal_setExternalUserId(externalUserId: email)
        
        let viewModel = AuthenticatorViewModel()
        viewModel.login(email, password: password).then { authUser -> Promise<GetUserActionResponse> in
            return CheqAPIManager.shared.getUserActions()
        }.done { userActionResponse in
            
            AppConfig.shared.hideSpinner {
                
                LoggingUtil.shared.cPrint("\n>> userActionResponse = \(userActionResponse)")
                
                switch (userActionResponse.userAction) {
                    
                case .genericInfo:
                    AppData.shared.completingDetailsForLending = false
                    self.gotoGenericInfoVC(response : userActionResponse)
                    break
                    
                case .categorisationInProgress:
                    AppData.shared.completingDetailsForLending = false
                    self.gotoCategorisationInProgressVC(response : userActionResponse)
                    break
                    
                case ._none:
                    AppData.shared.isOnboarding = false
                    AppData.shared.migratingToNewDevice = false
                    AppData.shared.completingDetailsForLending = false
                    self.navigateToDashboard()
                    break
                    
                case .actionRequiredByBank:
                    AppData.shared.completingDetailsForLending = false
                    self.gotoUserActionRequiredVC(response : userActionResponse)
                    break
                    
                case .bankNotSupported:
                    AppData.shared.completingDetailsForLending = false
                    self.gotoBankNotSupportedVC(response : userActionResponse)
                    break
                    
                case .invalidCredentials:
                    AppData.shared.completingDetailsForLending = false
                    AppNav.shared.pushToMultipleChoice(.financialInstitutions, viewController: self)
                    break
                    
                case .missingAccount:
                    
                    LoggingUtil.shared.cPrint("MissingAccount - this needs to call PUT v1/users to create basiq accounts")
                    AppConfig.shared.showSpinner()
                    
                    AuthConfig.shared.activeManager.getCurrentUser().then { authUser in
                        return CheqAPIManager.shared.putUser(authUser)
                    }.then { authUser in
                        AuthConfig.shared.activeManager.retrieveAuthToken(authUser)
                    }.then { authUser in
                        AuthConfig.shared.activeManager.setUser(authUser)
                    }.done { authUser in
                        AppConfig.shared.hideSpinner {
                            AppData.shared.completingDetailsForLending = false
                            AppNav.shared.pushToMultipleChoice(.financialInstitutions, viewController: self)
                            //AppNav.shared.pushToIntroduction(.setupBank, viewController: self)
                        }
                    }.catch { err in
                        AppConfig.shared.hideSpinner {
                                 LoggingUtil.shared.cPrint(err)
                                 LoggingUtil.shared.cPrint(err.localizedDescription)
                                self.showError(CheqAPIManagerError.errorHasOccurredOnServer) {
                                
                             }
                        }
                    }
                    break
                    
                case  .requireMigration,.requireBankLinking, .accountReactivation, .bankLinkingUnsuccessful:
                    //  UserAction: RequireMigration, RequireBankLinking, AccountReactivation
                    //  LinkedInstitutionId is not null, auto-select the bank by LinkedInstitutionId
                    //  LinkedInstitutionId is null, ask users to select institution from bank list
                    
                    AppConfig.shared.hideSpinner {
                        AppData.shared.completingDetailsForLending = false
                        AppNav.shared.pushToMultipleChoice(.financialInstitutions, viewController: self)
                        //AppNav.shared.pushToIntroduction(.setupBank, viewController: self)
                    }
                    break
                    
                case .none:
                    LoggingUtil.shared.cPrint("err")
                }
            }
            
        }.catch { err in
            AppConfig.shared.hideSpinner {
                // handle err
                self.handleLoginErr(err)
            }
        }
    }
    
    func handleLoginErr(_ err: Error) {
        // special case, if getUserDetails fails, then we go through onboarding process again
        // even if you have login with firebase account
        switch err {
        case CheqAPIManagerError.onboardingRequiredFromGetUserDetails:
            self.beginOnboarding()
        default:
            LoggingUtil.shared.cPrint(err)
            AppConfig.shared.hideSpinner {
                self.showError(err, completion: nil)
            }
        }
    }
}

//MARK: -  Navigation
extension SplashVC {
    
    func gotoHome(){
        
        LoggingUtil.shared.cPrint("go to home screen from splash")
        // Load to dashboard
        AppData.shared.isOnboarding = false
        AppData.shared.migratingToNewDevice = false
        AppData.shared.completingDetailsForLending = false
        self.navigateToDashboard()
    }
    
    func beginOnboarding() {
        self.view.endEditing(true)
        AppData.shared.isOnboarding = true
        AppConfig.shared.hideSpinner {
            guard let activeUser = AuthConfig.shared.activeUser else {
                self.showError(AuthManagerError.unableToRetrieveCurrentUser, completion: nil)
                return
            }
            if activeUser.type == .socialLoginEmail, activeUser.isEmailVerified == false {
                self.toEmailVerification()
            } else {
                // for Facebook emails
                //self.toPasscodeSetup()
                AppNav.shared.pushToQuestionForm(.legalName, viewController: self)
            }
        }
    }
    
    func toEmailVerification() {
        let emailVc = AppNav.shared.initViewController(StoryboardName.common.rawValue, storyboardId: CommonStoryboardId.emailVerify.rawValue, embedInNav: false)
        AppNav.shared.pushToViewController(emailVc, from: self)
    }
    
    func navigateToDashboard() {
        // go to dashboard board
        var vcInfo = [String: String]()
        vcInfo[NotificationUserInfoKey.storyboardName.rawValue] = StoryboardName.main.rawValue
        vcInfo[NotificationUserInfoKey.storyboardId.rawValue] = MainStoryboardId.tab.rawValue
        NotificationUtil.shared.notify(UINotificationEvent.switchRoot.rawValue, key: NotificationUserInfoKey.vcInfo.rawValue, object: vcInfo)
    }
    
    func gotoUserActionRequiredVC(response : GetUserActionResponse){
        self.view.endEditing(true)
        //guard let nav =  self.navigationController else { return }
        if let vc = AppNav.shared.initViewController(StoryboardName.common.rawValue, storyboardId: CommonStoryboardId.userActionRequiredVC.rawValue, embedInNav: false) as? UserActionRequiredVC {
            vc.getUserActionResponse = response
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
    
    func gotoGenericInfoVC(response : GetUserActionResponse){
        self.view.endEditing(true)
        if let vc = AppNav.shared.initViewController(StoryboardName.common.rawValue, storyboardId: CommonStoryboardId.GenericInfoVC.rawValue, embedInNav: false) as? GenericInfoVC {
            vc.getUserActionResponse = response
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
    
    func gotoBankNotSupportedVC(response : GetUserActionResponse){
        self.view.endEditing(true)
        if let vc = AppNav.shared.initViewController(StoryboardName.common.rawValue, storyboardId: CommonStoryboardId.BankNotSupportedVC.rawValue, embedInNav: false) as? BankNotSupportedVC {
            vc.getUserActionResponse = response
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
    
    func gotoCategorisationInProgressVC(response : GetUserActionResponse){
        self.view.endEditing(true)
        if let vc = AppNav.shared.initViewController(StoryboardName.common.rawValue, storyboardId: CommonStoryboardId.CategorisationInProgressVC.rawValue, embedInNav: false) as? CategorisationInProgressVC {
            vc.getUserActionResponse = response
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
}

