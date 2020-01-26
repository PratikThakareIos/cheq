//
//  ViewModelProtocol.swift
//  CheqDemo
//
//  Created by XUWEI LIANG on 7/8/19.
//  Copyright © 2019 WiseTree Solutions Pty Ltd. All rights reserved.
//

import UIKit

/// This is a base class for viewModels. Depending on what is the implementation pattern, **BaseViewModel** is designed for viewController viewModels that's based on scrollView instead of tableview.
class BaseViewModel {
    
    /// We alway define the screen name using **ScreeName** enum for convenience in tracking the user's navigation
    var screenName: ScreenName = .unknown
    
    /// In general, the API connectivity or any async tasks to setup the ViewController is embeded inside this method. But do not restrict to following this interface. 
    @objc func load(_ complete: @escaping () -> Void) { complete() }
}
