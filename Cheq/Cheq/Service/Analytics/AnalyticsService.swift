//
//  AnalyticsService.swift
//  Cheq
//
//  Created by iTelaSoft-PC on 11/28/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import Foundation

class AnalyticsService {
    
    //Analytics Options
    enum Analytics {
        case firebase
        case mixpanel
        case all
    }
    
    //Singleton Implementation for MixpanelService
    private static var analyticsService: AnalyticsService?
    private init () {
       
    }
    
    public static var shared: AnalyticsService {
        if analyticsService == nil {
            analyticsService = AnalyticsService();
        }
        
        return analyticsService!;
    }
    
    
    func initAnalytics(withOptions:[Analytics]) {
        
        for eventType in withOptions {
            switch eventType {
                
            case .firebase:
                print("Firebase Initialized")
                 break;
            case .mixpanel:
                MixpanelService.shared.initMixpanel()
                 break;
            case .all:
                 print("Firebase Initialized")
                 MixpanelService.shared.initMixpanel()
                 break;
            }
            
        }
        
    }
    
    
    func logEventToAnalytics(withOptions:[Analytics],tab:String)  {
        
        for eventType in withOptions {
            
            switch eventType {
                
            case .firebase:
                 print("Firebase log")
                 break;
            case .mixpanel:
                 MixpanelService.shared.trackEvent(tab: tab)
                 break;
            case .all:
                 print("Firebase Initialized")
                 MixpanelService.shared.trackEvent(tab: tab)
                 break;
            }
            
        }
     }
    
    
}

