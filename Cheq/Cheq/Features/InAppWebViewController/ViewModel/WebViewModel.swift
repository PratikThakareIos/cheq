//
//  WebViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 11/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import Foundation

class WebViewModel: BaseViewModel {
    
    var url: String = ""
    
    var isLoadHTML : Bool = false
    var message: String = ""
    var loanActivity: LoanActivity?
    
    
    override func load(_ complete: @escaping () -> Void) {}
}
