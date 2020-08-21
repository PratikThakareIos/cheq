//
//  VDotManager.swift
//  Cheq
//
//  Created by XUWEI LIANG on 24/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import UserNotifications
import DateToolsSwift
import PromiseKit

enum VDotLogKey: String {
    case email = "email"
    case worksheets = "worksheets"
    case atWork = "atWork"
    case dateTime = "dateTime"

}

class VDotManager: NSObject {
    
    static let shared = VDotManager()

    // date formatter
    let dateFormatter = DateFormatter()
    // time format
    let worksheetTimeFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    // geo fence threshold
    let geoFence = 100.0
    // metres
    let distanceFilter = 50.0

    // seconds
    let logInterval = 300 // 5 mins
    let flushInterval = 10800 // 3hrs
    // center reference for geo fencing
    // set to a date long back so we start tracking initially
    var lastTracked: Date = 100.years.earlier
    var lastFlush: Date = 100.years.earlier

    var atWork: Bool = false

    private override init () {
        super.init()
        dateFormatter.dateFormat = worksheetTimeFormat
        let localTimeZoneAbbreviation = TimeZone.current.abbreviation() ?? ""
        dateFormatter.timeZone = TimeZone(abbreviation: localTimeZoneAbbreviation)
    }

    func flushStoredData() {
        LoggingUtil.shared.cWriteToFile(LoggingUtil.shared.fcmMsgFile, newText: "flushStoredData")
    }

    func timeToLog()-> Bool {
        let now = Date()
        return Int(now.timeIntervalSince(lastTracked)) > self.logInterval
    }
    
    func timeToFlush()-> Bool {
        let now = Date()
        return Int(now.timeIntervalSince(lastFlush)) > self.flushInterval
    }
}

extension VDotManager {

    func cleanWorksheets()-> Bool {
        
        var dictionary = CKeychain.shared.getDictionaryByKey(CKey.vDotLog.rawValue)
        dictionary[VDotLogKey.worksheets.rawValue] = []
        return CKeychain.shared.setDictionary(CKey.vDotLog.rawValue, dictionary: dictionary)
    }

    func loadWorksheets()-> PostWorksheetRequest {
        
        let dictionary = CKeychain.shared.getDictionaryByKey(CKey.vDotLog.rawValue)
        let email =  CKeychain.shared.getValueByKey(CKey.loggedInEmail.rawValue)
        let workSheetsDictionaryArray = dictionary[VDotLogKey.worksheets.rawValue] as? Array<[String:Any]> ?? []
        var workSheets = [Worksheet]()
        workSheetsDictionaryArray.forEach { workSheetDict in
            let atWorkString = workSheetDict[VDotLogKey.atWork.rawValue] as? String ?? "false"
            let atWork = Bool(atWorkString)
            let dateTimeString = workSheetDict[VDotLogKey.dateTime.rawValue] as? String ?? ""
            let dateTime = Date(dateString: dateTimeString, format: worksheetTimeFormat)
            let workSheet = Worksheet(atWork: atWork, dateTime: dateTime,distanceMeters:nil)
            workSheets.append(workSheet)
        }
        return PostWorksheetRequest(email: email, worksheets: workSheets, geolocationDisabled: false)
    }
}
