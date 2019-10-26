//
//  Error_Extension.swift
//  Cheq
//
//  Created by Xuwei Liang on 26/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

extension Error {
    func code()->Int? {
        if let error = self as? ErrorResponse {
            switch error {
            case .error(let code, _, _):
                return code
            }
        }
        return nil
    }
}
