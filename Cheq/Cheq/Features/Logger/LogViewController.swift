//
//  LogViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 1/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit

//import MobileSDK

class LogViewController: UIViewController {
    
    let fcmMsgFile = "temp.txt"
    var textView: UITextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reload()
        AppConfig.shared.showSpinner()
        apiTest()
    }
    
    func apiTest() {
        
//        var credentials = [LoginCredentialType: String] ()
//        credentials[.email] = "hellotest4@gmail.com"
//        credentials[.password] = TestUtil.shared.randomPassword()
//        AuthConfig.shared.activeManager.register(.socialLoginEmail, credentials: credentials).then { authUser -> Promise<AuthUser> in
//            let req = TestUtil.shared.putUserDetailsReq()
//            return CheqAPIManager.shared.putUserDetails(req)
//        }.then { authUser->Promise<AuthenticationModel> in
//            return MoneySoftManager.shared.login(authUser.msCredential)
//        }.then { authModel->Promise<Bool> in
//            return MoneySoftManager.shared.postNotificationToken()
//        }.then { success->Promise<Bool> in
//            let fcmToken = CKeychain.shared.getValueByKey(CKey.fcmToken.rawValue)
//            let apns = CKeychain.shared.getValueByKey(CKey.apnsToken.rawValue)
//            let req = PostPushNotificationRequest(deviceId: UIDevice.current.identifierForVendor?.uuidString, firebasePushNotificationToken: fcmToken, applePushNotificationToken: apns, deviceType: .ios)
//            return CheqAPIManager.shared.postNotificationToken(req)
//        }.done { success in
//            let fcmToken = CKeychain.shared.getValueByKey(CKey.fcmToken.rawValue)
//            let _ = LoggingUtil.shared.printLocationFile("token : \(fcmToken), posted to moneySoft\n")
//        }.catch { err in
//            LoggingUtil.shared.cPrint(err.localizedDescription)
//        }.finally {
//            AppConfig.shared.hideSpinner {
//            }
//        }
        
        
    }
    
    func setup() {        
        self.textView = UITextView()
        self.textView.backgroundColor = .black
        self.textView.textColor = .cyan
        self.textView.isEditable = false
        self.view.addSubview(textView)
        AutoLayoutUtil.pinToSuperview(self.textView, padding: 0.0)
        let tap = UITapGestureRecognizer(target: self, action: #selector(reload))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func reload() {
        textView.text = LoggingUtil.shared.printLocationFile(self.fcmMsgFile)
    }
}
