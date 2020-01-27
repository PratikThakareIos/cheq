//
//  VDotManager.swift
//  Cheq
//
//  Created by XUWEI LIANG on 24/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications
import DateToolsSwift
import PromiseKit

enum VDotLogKey: String {
    case email = "email"
    case worksheets = "worksheets"
    case atWork = "atWork"
    case dateTime = "dateTime"
    case latitude = "latitude"
    case longitude = "longitude"
}

class VDotManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = VDotManager()
    var locationManager = CLLocationManager()

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
    // markedLocation gets updated when user fills Employer details
    var markedLocation = CLLocation(latitude: -33.8653556
, longitude: 151.205377)
    // set to a date long back so we start tracking initially
    var lastTracked: Date = 100.years.earlier
    var lastFlush: Date = 100.years.earlier

    var atWork: Bool = false

    private override init () {
        super.init()
        dateFormatter.dateFormat = worksheetTimeFormat
        let localTimeZoneAbbreviation = TimeZone.current.abbreviation() ?? ""
        dateFormatter.timeZone = TimeZone(abbreviation: localTimeZoneAbbreviation)
        self.setupLocationManager()
    }

    func setupLocationManager() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.distanceFilter = self.distanceFilter
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        self.locationManager.startMonitoringSignificantLocationChanges()
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.pausesLocationUpdatesAutomatically = false
    }

    func flushStoredData() {
        LoggingUtil.shared.cWriteToFile(LoggingUtil.shared.fcmMsgFile, newText: "flushStoredData")
        CheqAPIManager.shared.flushWorkTimesToServer().done { success in
            if success { let _ = self.cleanWorksheets() }
        }.catch { err in
            LoggingUtil.shared.cPrint(err)
        }
    }
    
    func isAtWork(_ location: CLLocation)-> Bool {
        let distance = self.markedLocation.distance(from: location)
        return distance <= self.geoFence ? true : false
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // get the last location
        guard let currentLocation = locations.last else { return }

        let now = Date()
        if self.timeToLog() {
            self.lastTracked = now
            let nowString = self.dateFormatter.string(from: now)
            self.atWork = self.isAtWork(currentLocation)
            self.logData(self.atWork, dateString: nowString, latitude: self.markedLocation.coordinate.latitude, longitude: self.markedLocation.coordinate.longitude)
        }
        
        if self.timeToFlush() {
            self.lastFlush = now
            self.flushStoredData()
        }
    }

    func logData(_ atWork: Bool, dateString: String, latitude: Double, longitude: Double) {
        var dictionary = CKeychain.shared.getDictionaryByKey(CKey.vDotLog.rawValue)
        dictionary[VDotLogKey.email.rawValue] = CKeychain.shared.getValueByKey(CKey.loggedInEmail.rawValue)
        var currentLogs:Array<Dictionary<String, Any>> = dictionary[VDotLogKey.worksheets.rawValue] as? Array<Dictionary<String, Any>> ?? []
        let newLog:Dictionary<String, Any> = [VDotLogKey.atWork.rawValue: String(atWork), VDotLogKey.dateTime.rawValue: dateString, VDotLogKey.latitude.rawValue: latitude, VDotLogKey.longitude.rawValue: longitude]
        currentLogs.append(newLog)
        dictionary[VDotLogKey.worksheets.rawValue] = currentLogs
        let _ = CKeychain.shared.setDictionary(CKey.vDotLog.rawValue, dictionary: dictionary)
        let timestamp = Date().timeStamp()
        LoggingUtil.shared.cWriteToFile(LoggingUtil.shared.fcmMsgFile, newText: "logData - \(timestamp)")
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
            let workSheet = Worksheet(atWork: atWork, dateTime: dateTime)
            workSheets.append(workSheet)
        }
        return PostWorksheetRequest(email: email, worksheets: workSheets)
    }
}
