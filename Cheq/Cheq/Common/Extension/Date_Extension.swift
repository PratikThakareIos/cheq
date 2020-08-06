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

extension Date {
    ///Find number of calendar days between two dates
    ///Comparing the ordinality of the two dates should be within the same era instead of the same year, since naturally the two dates may fall in different years.

    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {

        let currentCalendar = Calendar.current

        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }

        return end - start
    }
    
    
//    //Usage
//    let yesterday = Date(timeInterval: -86400, since: Date())
//    let tomorrow = Date(timeInterval: 86400, since: Date())
//
//
//    let diff = tomorrow.interval(ofComponent: .day, fromDate: yesterday)
//    // return 2
}




