//
//  PostUserDetailsForFrankieKYC.swift
//  Cheq
//
//  Created by Sachin Amrale on 11/09/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import Foundation

public struct PostUserDetailsForFrankieKYC: Codable {

    public var isConsent: Bool?
    
    public init(isConsent: Bool?) {
        self.isConsent = isConsent
    }
}


public struct PostUserNameDetailsForFrankie: Codable {
    public var firstName: String?
    public var middleName: String?
    public var lastName: String?
    public var showMiddleName: String?
    public var dateOfBirth: String?

    public init(firstName: String?, middleName: String?, lastName: String?, showMiddleName: String?, dateOfBirth: String?) {
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
        self.showMiddleName = showMiddleName
        self.dateOfBirth = dateOfBirth
    }
}

public struct PostUserResidentialAddressForFrankie: Codable {
    public var unitNumber: String?
    public var streetNumber: String?
    public var streetName: String?
    public var streetType: String?
    public var suburb: String?
    public var state: String?
    public var postCode: String?

    public init(unitNumber: String?, streetNumber: String?, streetName: String?, streetType: String?, suburb: String?, state: String?, postCode: String?) {
        self.unitNumber = unitNumber
        self.streetNumber = streetNumber
        self.streetName = streetName
        self.streetType = streetType
        self.suburb = suburb
        self.state = state
        self.postCode = postCode
    }
}

public struct PostUserDocumentDetailsForFrankieKYC: Codable{
    public var driverLicence: DriverLicence?
    public var passport: Passport?
    public var medicare: MedicareCard?

    public init(driverLicence: DriverLicence, passport: Passport, medicare: MedicareCard){
        self.driverLicence = driverLicence
        self.passport = passport
        self.medicare = medicare
    }
}

public struct DriverLicence: Codable {
    public var idNumber: String?
    public var state: String?

    public init(idNumber: String?, state: String?) {
        self.idNumber = idNumber
        self.state = state
    }
}

public struct Passport: Codable {
    public var idNumber: String?
    public var country: String?

    public init(idNumber: String?, country: String?) {
        self.idNumber = idNumber
        self.country = country
    }
}

public struct MedicareCard: Codable {
    public var idNumber: String?
    public var color: String?
    public var positionOnCard: String?
    public var validToMonth: Int?
    public var validToYear: Int?
    
    public init(idNumber: String?, color: String?, positionOnCard: String?, validToMonth: Int?, validToYear: Int?) {
        self.idNumber = idNumber
        self.color = color
        self.positionOnCard = positionOnCard
        self.validToMonth = validToMonth
        self.validToYear = validToYear
    }
}


