//
//  Date_Extension.swift
//  Cheq
//
//  Created by XUWEI LIANG on 1/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

extension Date {
    
    /// Timestamp String from current time. We apply timestamp whenever we see a new viewController, so that the Passcode screen doesn't show up because we keep track of user's recent visit of viewController 
    func timeStamp()-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm:ss a"
        let timeStamp = dateFormatter.string(from: self)
        return timeStamp 
    }
}
