//
//  ViewModelProtocol.swift
//  CheqDemo
//
//  Created by XUWEI LIANG on 7/8/19.
//  Copyright © 2019 WiseTree Solutions Pty Ltd. All rights reserved.
//

import UIKit

class BaseViewModel {

    var screenName: ScreenName = .unknown
    @objc func load(_ complete: @escaping () -> Void) { complete() }
}
