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
}

class VDotManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = VDotManager()
    var locationManager = CLLocationManager()

    // date formatter
    let dateFormatter = DateFormatter()

    // geo fence threshold
    let geoFence = 10.0
    // metres
    let distanceFilter = 1.0

    // seconds
    let logInterval = 10
    let flushInterval = 60
    // center reference for geo fencing
    var markedLocation = CLLocation(latitude: -33.8653556
, longitude: 151.205377)
    // set to a date long back so we start tracking initially
    var lastTracked: Date = 100.years.earlier
    var lastFlush: Date = 100.years.earlier

    var atWork: Bool = false

    private override init () {
        super.init()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        self.setupLocationManager()
    }

    func setupLocationManager() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = self.distanceFilter
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        self.locationManager.startMonitoringSignificantLocationChanges()
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.pausesLocationUpdatesAutomatically = false
    }

    func flushStoredData() {
        CheqAPIManager.shared.flushWorkTimesToServer().done { success in
            if success { let _ = self.cleanWorksheets() }
        }.catch { err in
            LoggingUtil.shared.cPrint(err)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // get the last location
        guard let currentLocation = locations.last else { return }

        let now = Date()
        if self.timeToLog() {
            self.lastTracked = now
            let nowString = self.dateFormatter.string(from: now)
            let distance = self.markedLocation.distance(from: currentLocation)
            self.atWork = distance <= self.geoFence ? true : false
            self.logData(self.atWork, dateString: nowString)
        }
        
        if self.timeToFlush() {
            self.lastFlush = now 
            self.flushStoredData()
        }
    }

    func logData(_ atWork: Bool, dateString: String) {
        var dictionary = CKeychain.getDictionaryByKey(CKey.vDotLog.rawValue)
        dictionary[VDotLogKey.email.rawValue] = CKeychain.getValueByKey(CKey.loggedInEmail.rawValue)
        var currentLogs:Array<Dictionary<String, Any>> = dictionary[VDotLogKey.worksheets.rawValue] as? Array<Dictionary<String, Any>> ?? []
        let newLog:Dictionary<String, Any> = [VDotLogKey.atWork.rawValue: String(atWork), VDotLogKey.dateTime.rawValue: dateString]
        currentLogs.append(newLog)
        dictionary[VDotLogKey.worksheets.rawValue] = currentLogs
        let _ = CKeychain.setDictionary(CKey.vDotLog.rawValue, dictionary: dictionary)
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
        var dictionary = CKeychain.getDictionaryByKey(CKey.vDotLog.rawValue)
        dictionary[VDotLogKey.worksheets.rawValue] = []
        return CKeychain.setDictionary(CKey.vDotLog.rawValue, dictionary: dictionary)
    }

    func loadWorksheets()-> PostWorksheetRequest {
        let dictionary = CKeychain.getDictionaryByKey(CKey.vDotLog.rawValue)
        let email =  CKeychain.getValueByKey(CKey.loggedInEmail.rawValue)
        let workSheetsDictionaryArray = dictionary[VDotLogKey.worksheets.rawValue] as? Array<[String:Any]> ?? []
        var workSheets = [Worksheet]()
        workSheetsDictionaryArray.forEach { workSheetDict in
            let atWorkString = workSheetDict[VDotLogKey.atWork.rawValue] as? String ?? "false"
            let atWork = Bool(atWorkString)
            let dateTimeString = workSheetDict[VDotLogKey.dateTime.rawValue] as? String ?? ""
            let dateTime = VDotManager.shared.dateFormatter.date(from: dateTimeString)
            let workSheet = Worksheet(atWork: atWork, dateTime: dateTime)
            workSheets.append(workSheet)
        }
        return PostWorksheetRequest(email: email, worksheets: workSheets)
    }
}
