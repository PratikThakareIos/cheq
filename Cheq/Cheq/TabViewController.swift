//
//  TabViewController.swift
//  CheqDemo
//
//  Created by XUWEI LIANG on 7/8/19.
//  Copyright © 2019 WiseTree Solutions Pty Ltd. All rights reserved.
//

import UIKit
import PromiseKit

class TabViewController: UITabBarController {

    let theme = sharedAppConfig.activeTheme

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = sharedAppConfig.activeTheme.backgroundColor
        self.selectedIndex = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
              self.checkUserActions()
        })
    }
    

    func checkUserActions() {
        
            AppConfig.shared.showSpinner()
            AuthConfig.shared.activeManager.getCurrentUser().then { authUser->Promise<GetUserActionResponse> in
                //When the user opens the app the apps checks if the user has a basiq account or not
                return CheqAPIManager.shared.getUserActions()
            }.done { userActionResponse in
                /*
                The backend will return one of these condition

                RequireMigration - User has not linked their bank account with Basiq yet
                InvalidBankCredentials - Since the user has last opened their app Basiq has informed us that they are not able to access the user’s account as  they have changed their password
                ActionRequiredByBank - this is when the user needs to perform an action on their bank account before they can access their bank
                AccountReactivation- this occurs when the user has not logged in to the Cheq app and they need to “relink” their bank
                BankNotSupported - this occurs when the user’s bank is no longer supported.
                MissingAccount - this needs to call PUT v1/users to create basiq accounts
                 
                if there is no issue with the user (none of these states are active) then the user proceeds to the spending dashboard as normal.
                */
                
                AppConfig.shared.hideSpinner {
                    LoggingUtil.shared.cPrint("\n>> TabViewController = \(userActionResponse)")
                   
                    switch (userActionResponse.userAction){
                        
                    case ._none:
                            break
                        
                    case .bankLinkingUnsuccessful :
                            self.gotoBankListScreen(response : userActionResponse)
                            break
                    
                    case .categorisationInProgress:
                            self.gotoBankListScreen(response : userActionResponse)
                            break
                            
                    case .actionRequiredByBank:
                            self.gotoBankListScreen(response : userActionResponse)
                            break
                        
                    case .bankNotSupported:
                            self.gotoBankListScreen(response : userActionResponse)
                            break
                        
                    case .invalidCredentials:
                            self.gotoBankListScreen(response : userActionResponse)
                            break
                        
                    case .missingAccount:
                           self.gotoBankListScreen(response : userActionResponse)
                           break
                        
                    case  .requireMigration,.requireBankLinking, .accountReactivation:
    //                     UserAction: RequireMigration, RequireBankLinking, AccountReactivation
    //                     LinkedInstitutionId is not null, auto-select the bank by LinkedInstitutionId
    //                     LinkedInstitutionId is null, ask users to select institution from bank list
                           self.gotoBankListScreen(response : userActionResponse)
                           break
                        
                    case .none:
                         LoggingUtil.shared.cPrint("TabViewController case none")
                        
                    }
                }
                
            }.catch { err in
                AppConfig.shared.hideSpinner {
                    // handle err
                    LoggingUtil.shared.cPrint("\n>> TabViewController = \(err)")
                }
            }
        }
    
    func gotoBankListScreen(response : GetUserActionResponse){
          AppData.shared.completingDetailsForLending = false
          AppConfig.shared.hideSpinner {
             LoggingUtil.shared.cPrint("go to bank list screen")
             NotificationUtil.shared.notify(UINotificationEvent.switchRootToBank.rawValue, key: NotificationUserInfoKey.vcInfo.rawValue, object: nil)
          }
    }
 
}
