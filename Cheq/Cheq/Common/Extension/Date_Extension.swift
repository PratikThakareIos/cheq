//
//  Date_Extension.swift
//  Cheq
//
//  Created by XUWEI LIANG on 1/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/*
Wednesday, Sep 12, 2018           --> EEEE, MMM d, yyyy
09/12/2018                        --> MM/dd/yyyy
09-12-2018 14:11                  --> MM-dd-yyyy HH:mm
Sep 12, 2:11 PM                   --> MMM d, h:mm a
September 2018                    --> MMMM yyyy
Sep 12, 2018                      --> MMM d, yyyy
Wed, 12 Sep 2018 14:11:54 +0000   --> E, d MMM yyyy HH:mm:ss Z
2018-09-12T14:11:54+0000          --> yyyy-MM-dd'T'HH:mm:ssZ
12.09.18                          --> dd.MM.yy
10:41:02.112                      --> HH:mm:ss.SSS
*/


extension Date {
    
    /// Timestamp String from current time. We apply timestamp whenever we see a new viewController, so that the Passcode screen doesn't show up because we keep track of user's recent visit of viewController 
    func timeStamp()-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm:ss a"
        let timeStamp = dateFormatter.string(from: self)
        return timeStamp 
    }
}




