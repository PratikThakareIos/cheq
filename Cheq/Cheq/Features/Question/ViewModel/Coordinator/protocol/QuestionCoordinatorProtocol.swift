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
    var question: String { get }
    var numOfTextFields: Int { get }
    
    func placeHolder(_ index: Int)->String
    
    func validateInput(_ inputs: [String: Any])-> ValidationError?
}

extension QuestionCoordinatorProtocol {
    
    // default is 1 
    var numOfTextFields: Int {
        get {
            return 1
        }
    }
}
