//
//  Mixpanel.swift
//  Cheq
//
//  Created by iTelaSoft-PC on 11/26/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import Foundation
import Mixpanel
import NotificationCenter

class MixpanelService {
    
    //Singleton Implementation for MixpanelService
    private static var mixpanelService: MixpanelService?
    private init () {
        addObservables()
    }
    
    public static var shared: MixpanelService {
        if mixpanelService == nil {
           mixpanelService = MixpanelService();
        }
        return mixpanelService!;

    }
    
    deinit {
        // remove all notification observable
        NotificationCenter.default.removeObserver(self)
    }
    
    func addObservables() {
        // add observer here
        NotificationCenter.default.addObserver(self, selector: #selector(handleMixEventAction(_:)), name: NSNotification.Name(UINotificationEvent.mixPanelEvent.rawValue), object: nil)
    }
    
    @objc func handleMixEventAction(_ notification: NSNotification) {
         // some handling logic and pass to mix panel sdk
        guard let path = notification.userInfo?[NotificationUserInfoKey.mixpanel.rawValue] as? String else { return }
        if path == AccountInfo.privacyPolicy.rawValue {
            
            trackEvent(tab: MixpanelEvents.privacy_tab.rawValue)
            
        }else if path == AccountInfo.termsAndConditions.rawValue{
            
            trackEvent(tab: MixpanelEvents.terms_conditions_tab.rawValue)
        }else{
            return;
        }
       
    }
    
    //Initialize initMixpanel and log the app launch event
    func initMixpanel() {
        
        Mixpanel.initialize(token:MixpanelProperties.mixpanel_token.rawValue)
        
        var mixpanelID = UserDefaults.standard.object(forKey: MixpanelIDs.mixpanel_ID.rawValue)
        
        if (mixpanelID == nil) {
            mixpanelID = MixpanelProperties.user_email.rawValue//Set the actual email
            UserDefaults.standard.set(mixpanelID, forKey: MixpanelIDs.mixpanel_ID.rawValue)
        }
        
        Mixpanel.mainInstance().identify(distinctId: mixpanelID as! String)
//        Mixpanel.mainInstance().registerSuperProperties(["Organization" : MixpanelIDs.organization_ID.rawValue])
        Mixpanel.mainInstance().track(event: MixpanelEvents.app_launched.rawValue)
        
    }
    
    //Track Events
    func trackEvent(tab:String) {
        Mixpanel.mainInstance().track(event: tab, properties: ["Time of the Event": FormatterUtil.shared.defaultDateFormatter().string(from:  Date())])
        Mixpanel.mainInstance().people.set(property:"Latest Time Record", to: FormatterUtil.shared.defaultDateFormatter().string(from:  Date()))
        Mixpanel.mainInstance().people.set(property:"Name of the user", to: MixpanelProperties.user_name.rawValue)
        Mixpanel.mainInstance().people.increment(property: "\(tab) hits",by: 1)
    }
    
}
