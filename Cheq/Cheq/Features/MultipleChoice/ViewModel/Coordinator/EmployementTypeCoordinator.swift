//
//  EmployementTypeCoordinator.swift
//  Cheq
//
//  Created by Xuwei Liang on 20/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit

enum EmploymentType: String {
    case fulltime = "Full time"
    case onDemand = "On Demand"
    case contract = "Contractor"
    case casual = "Casual Employee"
    case selfEmployed = "Self employed"
    case partTime = "Part time"
    
    init(fromRawValue: String) {
        self = EmploymentType(rawValue: fromRawValue) ?? .fulltime
    }
}

struct EmployementTypeCoordinator: MultipleChoiceViewModelCoordinator {
    var sectionTitle = Section.employmentDetails.rawValue
    var questionTitle = "Employment type"
    var coordinatorType: MultipleChoiceQuestionType = .employmentType
    
    func choices() -> Promise<[ChoiceModel]> {
        return Promise<[ChoiceModel]>() { resolver in
            let fullTime = ChoiceModel(type: .choiceWithCaption, title: EmploymentType.fulltime.rawValue, caption: "You work 38 hours or more per week", image: nil, ordering: 0, ref : nil)
            let onDemand = ChoiceModel(type: .choiceWithCaption, title: EmploymentType.onDemand.rawValue, caption: "You work for an on demand company \ne.g. Uber, Airtasker, etc.", image: nil,  ordering: 0, ref : nil)
            let contractual = ChoiceModel(type: .choiceWithCaption, title: EmploymentType.contract.rawValue, caption: "You have a contract and get paid by invoicing the employer", image: nil,  ordering: 0, ref : nil)
            let casual = ChoiceModel(type: .choiceWithCaption, title: EmploymentType.casual.rawValue, caption: "You work Irregular hours and don't have a set number of working hours. ", image: nil,  ordering: 0, ref : nil)
            let selfEmployed = ChoiceModel(type: .choiceWithCaption, title: EmploymentType.selfEmployed.rawValue, caption: "Self employed", image: nil,  ordering: 0, ref : nil)
            let partTime = ChoiceModel(type: .choiceWithCaption, title: EmploymentType.partTime.rawValue, caption: "You work less than 38 hours  per week", image: nil,  ordering: 0, ref : nil)
            let result = [fullTime, partTime, onDemand, contractual, casual]
            resolver.fulfill(result)
        }
    }
    

}




enum WorkLocationType: String {
    case fixLocation = "From a fixed location"
    case multipleLocations = "From multiple locations"
    case remoteLocation = "From home/remote"
    
    
    init(fromRawValue: String) {
        self = WorkLocationType(rawValue: fromRawValue) ?? .fixLocation
    }
}

struct WorkLocationTypeCoordinator: MultipleChoiceViewModelCoordinator {
    var sectionTitle = Section.employmentDetails.rawValue
    var questionTitle = "Where do you work most of the time?"
    var coordinatorType: MultipleChoiceQuestionType = .workingLocation
    
    func choices() -> Promise<[ChoiceModel]> {
        return Promise<[ChoiceModel]>() { resolver in
            let fixedLocation = ChoiceModel(type: .choiceWithCaption, title: WorkLocationType.fixLocation.rawValue, caption: "You work from one location every \nday e.g. office.", image: nil, ordering: 0, ref : nil)
            let multipleLocations = ChoiceModel(type: .choiceWithCaption, title: WorkLocationType.multipleLocations.rawValue, caption: "You move around every day for work \nfrom site to site e.g. salesperson.", image: nil,  ordering: 0, ref : nil)
            let remoteLocation = ChoiceModel(type: .choiceWithCaption, title: WorkLocationType.multipleLocations.rawValue, caption: "You work from your own home.", image: nil,  ordering: 0, ref : nil)
            
            let result = [fixedLocation, multipleLocations, remoteLocation]
            resolver.fulfill(result)
        }
    }
    

}
