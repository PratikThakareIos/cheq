//
//  ViewModelProtocol.swift
//  CheqDemo
//
//  Created by XUWEI LIANG on 7/8/19.
//  Copyright © 2019 WiseTree Solutions Pty Ltd. All rights reserved.
//

import UIKit

protocol BaseViewModel {
    func load(_ complete: @escaping ()->Void)
}

extension BaseViewModel {
    func load(_ complete: @escaping () -> Void) { complete() }
}
