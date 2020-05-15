//
//  DynamicFormViewModelCoordinator.swift
//  Cheq
//
//  Created by Xuwei Liang on 20/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit

protocol DynamicFormViewModelCoordinator {
    var sectionTitle: String { get }
    var viewTitle: String { get }
    
    func loadForm() -> Promise<[DynamicFormInput]>
    func submitForm()->Promise<Bool>
    func nextViewController()
        
    func submitFormWith(loginId : String?, password : String?, securityCode : String?, secondaryLoginId : String?, isUpdateConnection :Bool)->Promise<Bool>
    func checkConnectionJobStatus() -> Promise<GetConnectionJobResponse>
}

