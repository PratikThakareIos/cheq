//
//  Error_Extension.swift
//  Cheq
//
//  Created by Xuwei Liang on 26/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

extension Error {
    
    /// extract the error code as int from this Error object. If it is **ErrorResponse**
    func code()->Int? {
        if let error = self as? ErrorResponse {
            switch error {
            case .error(let code, _, _):
                return code
            }
        }
        return nil
    }
    
    
    /// extract the message from this Error. If it is **ErrorResponse** 
    func message()->String? {
        if let error = self as? ErrorResponse {
            switch error {
            case .error(_, _, let err):
                return err.localizedDescription
            }
        }
        return nil
    }
}
