//
//  MixpanelEnums.swift
//  Cheq
//
//  Created by iTelaSoft-PC on 11/26/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import Foundation


enum MixpanelEvents: String {
    
    //Events
    case app_launched = "App Launched"
    case profile_tab = "Profile Tab Clicked"
    case terms_conditions_tab = "Terms & Conditions Tab Clicked"
    case privacy_tab = "Privacy Tab Clicked"
    case logout = "logout Clicked"
}

enum MixpanelIDs: String {

    //IDs
    case mixpanel_ID = "Mixpanel ID"
//    case organization_ID = "iTelaSoft Pvt Ltd"
}

enum MixpanelProperties: String {
    
    //Configurations
    case mixpanel_token = "3bf39f3a1cf09629daccc32a01426adb"
    case user_email = "danutha.fernando@itelasoft.com"
    case user_name = "Danutha Fernando"
}


