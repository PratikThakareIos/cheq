//
//  TabViewController.swift
//  CheqDemo
//
//  Created by XUWEI LIANG on 7/8/19.
//  Copyright © 2019 WiseTree Solutions Pty Ltd. All rights reserved.
//

import UIKit
import PromiseKit

class TabViewController: UITabBarController, UITabBarControllerDelegate {

    let theme = sharedAppConfig.activeTheme
    var previousSelectedIndex = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = sharedAppConfig.activeTheme.backgroundColor
        self.selectedIndex = 0
        previousSelectedIndex = self.selectedIndex
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
              self.checkUserActions()
              //self.setbackGroundImage()
        })
    }
    
//    override func viewWillAppear(_ animated: Bool) {
////       DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
////              self.setbackGroundImage()
////        })
//    }
    
//    func setbackGroundImage() {
//
//        let img = UIImage(named: "Rectangle")
//        if let image = img {
//            let centerImage: Bool = false
//            var resizeImage: UIImage?
//            let size = CGSize(width: UIScreen.main.bounds.size.width, height: 98)
//            UIGraphicsBeginImageContextWithOptions(size, false, 0)
//            if centerImage {
//                //if you want to center image, use this code
//                image.draw(in: CGRect(origin: CGPoint(x: (size.width-image.size.width)/2, y: 0), size: image.size))
//            }
//            else {
//                //stretch image
//                image.draw(in: CGRect(origin: CGPoint.zero, size: size))
//            }
//            resizeImage = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//            tabBar.backgroundImage = resizeImage?.withRenderingMode(.alwaysOriginal)
//        }
//    }
    
    
    
    // UITabBarDelegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
       // print("Selected item \(String(describing: tabBar.selectedItem))")
    }

    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
                
        let tabBarIndex = tabBarController.selectedIndex
        if previousSelectedIndex == tabBarIndex {
            //when tap on the same Tab then refresh the API on selected controller
            print("previousSelectedIndex \(previousSelectedIndex)")
            
            switch tabBarIndex {
                 case 0:
                         //Spending
                    NotificationUtil.shared.notify(UINotificationEvent.spendingOverviuew.rawValue, key: "", value: "")
                    AppConfig.shared.addEventToFirebase(PassModuleScreen.Menu.rawValue, FirebaseEventKey.menu_spend.rawValue, FirebaseEventKey.menu_spend.rawValue, FirebaseEventContentType.button.rawValue)
                
                 case 1:
                        //Lending
                    NotificationUtil.shared.notify(UINotificationEvent.lendingOverview.rawValue, key: "", value: "")
                    AppConfig.shared.addEventToFirebase(PassModuleScreen.Menu.rawValue, FirebaseEventKey.menu_lend.rawValue,  FirebaseEventKey.menu_lend.rawValue, FirebaseEventContentType.button.rawValue)

                 case 2:
                        //Account
                    NotificationUtil.shared.notify(UINotificationEvent.accountInfo.rawValue, key: "", value: "")
                    AppConfig.shared.addEventToFirebase(PassModuleScreen.Menu.rawValue, FirebaseEventKey.menu_profile.rawValue, FirebaseEventKey.menu_profile.rawValue, FirebaseEventContentType.button.rawValue)
                    
                 default:
                         break
            }
        }
        previousSelectedIndex = tabBarIndex
    }

    func checkUserActions() {

            AppConfig.shared.showSpinner()
            AuthConfig.shared.activeManager.getCurrentUser().then { authUser in
                AuthConfig.shared.activeManager.retrieveAuthToken(authUser)
            }.then { authUser->Promise<GetUserActionResponse> in
                //When the user opens the app the apps checks if the user has a basiq account or not
                self.addLog_callingGetUserActions()
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
                
                self.addLog_EndCallingGetUserActions(strRes: "\(String(describing: userActionResponse.userAction))")
                LoggingUtil.shared.addLogsToServer()
                
                AppConfig.shared.hideSpinner {
                    LoggingUtil.shared.cPrint("\n>> TabViewController = \(userActionResponse)")
                   
                    switch (userActionResponse.userAction) {
                                                
                    case ._none:
                           break
                        
                    case .genericInfo:
                            self.gotoBankListScreen(response : userActionResponse)
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
                           self.gotoBankListScreen(response : userActionResponse)
                           break
                        
                    case .none:

                          break
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

extension TabViewController {
    
    func addLog_callingGetUserActions(){
        let strMessage = "On Tab - start calling  getUserActions - \(Date().timeStamp())"
        let strEvent = "getUserActions"
        let log = PostLogRequest(deviceId: UUID().uuidString, type: .info, message: strMessage, event: strEvent, bankName: "")
        LoggingUtil.shared.addLog(log: log)
    }
    
    func addLog_EndCallingGetUserActions(strRes : String){
        let strMessage = "On Tab - End calling getUserActions - \(Date().timeStamp()) - respense \(strRes)"
        let strEvent = "getUserActions"
        let log = PostLogRequest(deviceId: UUID().uuidString, type: .info, message: strMessage, event: strEvent, bankName: "")
        LoggingUtil.shared.addLog(log: log)
    }

}
