//
//  BluedotManager.swift
//  Cheq
//
//  Created by Xuwei Liang on 6/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import BDPointSDK

class BluedotManager: NSObject {
    let apiKey = "7b9b43d0-d39d-11e9-82e5-0ad12f17ff82"
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    static let shared = BluedotManager()
    private override init() {
        super.init()
        BDLocationManager.instance()?.sessionDelegate = self
        BDLocationManager.instance()?.locationDelegate = self
        //MARK: Authenticate
        //Determine the authetication state
        let bluedotKey = CKeychain.getValueByKey(CKey.bluedotAPIKey.rawValue)
        let key = bluedotKey.isEmpty ? bluedotKey : apiKey
        switch BDLocationManager.instance()!.authenticationState {
        case .notAuthenticated:
            BDLocationManager.instance()?.authenticate(withApiKey: key, requestAuthorization: BDAuthorizationLevel.authorizedAlways)
        default:
            break
        }
    }
}

// MARK: BDPSessionDelegate
extension BluedotManager: BDPSessionDelegate {
    
    func willAuthenticate(withApiKey: String!) {
        print( "Authenticating with Point sdk" )
    }
    
    func authenticationWasSuccessful() {
        LoggingUtil.shared.cPrint( "Authenticated successfully with Point sdk" )
    }
    
    func authenticationWasDenied(withReason reason: String!) {
        guard let reasonText = reason else { return }
        LoggingUtil.shared.cPrint("Authentication with Point sdk denied, with reason: \(reasonText)")
    }
    
    func authenticationFailedWithError(_ error: Error!) {
        LoggingUtil.shared.cPrint( "Authentication with Point sdk failed, with reason: \(error.localizedDescription)" )
    }
    
    func didEndSession() {
        print("Logged out")
    }
    
    func didEndSessionWithError( _ error: Error! ) {
        print("Logged out with error: \(error.localizedDescription)")
    }
}

// MARK: BDPLocationDelegate
extension BluedotManager: BDPLocationDelegate {
    
    //MARK: This method is passed the Zone information utilised by the Bluedot SDK.
    func didUpdateZoneInfo(_ zoneInfos: Set<AnyHashable>) {
        print("zone information is received")
    }
    
    //MARK: checked into a zone
    //fence         - Fence triggered
    //zoneInfo      - Zone information Fence belongs to
    //location      - Geographical coordinate where trigger happened
    //customData    - Custom data associated with this Custom Action
    func didCheck(intoFence fence: BDFenceInfo!, inZone zoneInfo: BDZoneInfo!, atLocation location: BDLocationInfo!, willCheckOut: Bool, withCustomData customData: [AnyHashable : Any]!) {
        LoggingUtil.shared.cPrint("You have checked into a zone")
    }
    
    //MARK: Checked out from a zone
    //fence             - Fence user is checked out from
    //zoneInfo          - Zone information Fence belongs to
    //checkedInDuration - Time spent inside the Fence in minutes
    //customData        - Custom data associated with this Custom Action
    func didCheckOut( fromFence fence: BDFenceInfo!, inZone zoneInfo: BDZoneInfo!, on date: Date!, withDuration checkedInDuration: UInt, withCustomData customData: [AnyHashable : Any]! ) {
        LoggingUtil.shared.cPrint("checked out from a zone")
    }
    
    //MARK: A beacon with a Custom Action has been checked into; display an alert to notify the user.
    //beacon         - Beacon triggered
    //zoneInfo       - Zone information Beacon belongs to
    //locationInfo   - Geographical coordinate where trigger happened
    //proximity      - Proximity at which the trigger occurred
    //customData     - Custom data associated with this Custom Action
    func didCheck(intoBeacon beacon: BDBeaconInfo!, inZone zoneInfo: BDZoneInfo!, atLocation locationInfo: BDLocationInfo!, with proximity: CLProximity, willCheckOut: Bool, withCustomData customData: [AnyHashable : Any]!) {
        LoggingUtil.shared.cPrint("You have checked into beacon \(beacon.name!) in zone \(zoneInfo.name!), at \(locationInfo.timestamp! )")
    }
    
    //MARK: A beacon with a Custom Action has been checked out from; display an alert to notify the user.
    //beacon               - Beacon triggered
    //zoneInfo             - Zone information Beacon belongs to
    //checkedInDuration    - Time spent inside the Fence; in minutes
    //customData           - Custom data associated with this Custom Action
    //proximity            - Proximity at which the trigger occurred
    func didCheckOut(fromBeacon beacon: BDBeaconInfo!, inZone zoneInfo: BDZoneInfo!, with proximity: CLProximity, on date: Date!, withDuration checkedInDuration: UInt, withCustomData customData: [AnyHashable : Any]!) {
        LoggingUtil.shared.cPrint("You have checked out from beacon \(beacon.name!) in zone \(zoneInfo.name!), after \(checkedInDuration) minutes)")
    }
    
    //MARK: This method is part of the Bluedot location delegate and is called when Bluetooth is required by the SDK but is not enabled on the device; requiring user intervention.
    func didStartRequiringUserInterventionForBluetooth() {
        LoggingUtil.shared.cPrint("didStartRequiringUserInterventionForBluetooth called")
    }
    
    //MARK: This method is part of the Bluedot location delegate; it is called if user intervention on the device had previously been required to enable Bluetooth and either user intervention has enabled Bluetooth or the Bluetooth service is no longer required.
    func didStopRequiringUserInterventionForBluetooth() {
        LoggingUtil.shared.cPrint("didStopRequiringUserInterventionForBluetooth called")
    }
    
    //MARK:  This method is part of the Bluedot location delegate and is called when Location Services are not enabled on the device; requiring user intervention.
    func didStartRequiringUserIntervention(forLocationServicesAuthorizationStatus authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .denied:
            LoggingUtil.shared.cPrint("didStartRequiringUserIntervention - authorizationStatus - denied")
        case .authorizedWhenInUse:
            LoggingUtil.shared.cPrint("didStartRequiringUserIntervention - authorizationStatus - authorizedWhenInUse")
        default:
            return
        }
    }
    
    //MARK: This method is part of the Bluedot location delegate; it is called if user intervention on the device had previously been required to enable Location Services and either Location Services has been enabled or the user is no longer within anauthenticated session, thereby no longer requiring Location Services.
    func didStopRequiringUserIntervention(forLocationServicesAuthorizationStatus authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .denied:
            LoggingUtil.shared.cPrint("didStopRequiringUserIntervention - authorizationStatus - denied")
        case .authorizedWhenInUse:
            LoggingUtil.shared.cPrint("didStopRequiringUserIntervention - authorizationStatus - authorizedWhenInUse")
        default:
            LoggingUtil.shared.cPrint("didStopRequiringUserIntervention")
            return
        }
    }
    
    //MARK: This method is part of the Bluedot location delegate and is called when Low Power mode is enabled on the device; requiring user intervention to restore full SDK precision.
    func didStartRequiringUserInterventionForPowerMode() {
        LoggingUtil.shared.cPrint("didStartRequiringUserInterventionForPowerMode")
    }
    
    //MARK: if the user switches off 'Low Power mode', then didStopRequiringUserInterventionForPowerMode is called.
    func didStopRequiringUserInterventionForPowerMode() {
        LoggingUtil.shared.cPrint("didStopRequiringUserInterventionForPowerMode")
    }
}
