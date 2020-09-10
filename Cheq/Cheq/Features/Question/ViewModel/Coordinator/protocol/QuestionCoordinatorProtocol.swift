//
//  QuestionCoordinatorProtocol.swift
//  Cheq
//
//  Created by Xuwei Liang on 3/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

protocol QuestionCoordinatorProtocol {
    var type: QuestionType { get }
    var sectionTitle: String { get }
    var question: String { get }
    var hintImage: UIImage? { get }
    var numOfTextFields: Int { get }
    var numOfCheckBox: Int { get }
    var numOfImageContainer: Int { get }
    func placeHolder(_ index: Int)->String
    func isEditable(at index: Int) -> Bool

    func validateInput(_ inputs: [String: Any])-> ValidationError?
}

extension QuestionCoordinatorProtocol {
    
    // default is 1 
    var numOfTextFields: Int {
        get {
            return 1
        }
    }

    // default is 0
    var numOfCheckBox: Int {
        get {
            return 0 
        }
    }
     // default is 0
    var numOfImageContainer: Int {
        get {
            return 0
        }
    }

    var sectionTitle: String {
        get {
            return Section.aboutMe.rawValue
        }
    }
    
    var hintImage: UIImage? {
        nil
    }
    
    func isEditable(at index: Int) -> Bool {
        true
    }
    
}
