//
//  Date_Extension.swift
//  Cheq
//
//  Created by XUWEI LIANG on 1/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

extension Date {
    func timeStamp()-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm:ss a"
        let timeStamp = dateFormatter.string(from: self)
        return timeStamp 
    }
}
