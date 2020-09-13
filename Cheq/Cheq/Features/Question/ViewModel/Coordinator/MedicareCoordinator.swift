//
//  MedicareCoordinator.swift
//  Cheq
//
//  Created by Alexey on 09.09.2020.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

struct MedicareCardColorItem: CSegmentedControlItem {
    enum CardColor: String {
        case green
        case yellow
        case blue
    }

    let title: String
    let color: CardColor
    
    var ref: Any? {
        self
    }
}

class MedicareCoordinator: QuestionCoordinatorProtocol {

    static let cardColors = [
            MedicareCardColorItem(title: "Green", color: .green),
            MedicareCardColorItem(title: "Yellow", color: .yellow),
            MedicareCardColorItem(title: "Blue", color: .blue)]
    
    var type: QuestionType = .medicare
    var sectionTitle: String { Section.verifyMyIdentity.rawValue }

    var question: String = "Your Medicare card details"
    var numOfTextFields: Int = 3
    
    var selectedCardColor: MedicareCardColorItem? = MedicareCoordinator.cardColors.first
    
    func segmentedControlConfig() -> (String, [CSegmentedControlItem])? {
        ("Medicare Card Colour", MedicareCoordinator.cardColors)
    }
    
    func onSegmentedControlChange(to selection: CSegmentedControlItem?) {
        if let c = selection as? MedicareCardColorItem {
            selectedCardColor = c
        }
    }
    
    func placeHolder(_ index: Int)->String {
        switch index {
        case 0:
            return "Card Number"
        case 1:
            return "Position on Card"
        case 2:
            return "Valid to"
        default:
            return ""
        }
    }
    
    var hintImage: UIImage? {
        UIImage(named: "ic_medicare_\(selectedCardColor?.color.rawValue ?? "")")
    }
    
    func validateInput(_ inputs: [String: Any]) -> ValidationError? {
        
        guard let cardNumber = inputs[placeHolder(0)] as? String, let positionOnCard = inputs[placeHolder(1)] as? String, let validTo = inputs[placeHolder(2)] as? String else { return ValidationError.allFieldsMustBeFilled }
        
        guard !cardNumber.isEmpty, !positionOnCard.isEmpty, !validTo.isEmpty else {
            return ValidationError.allFieldsMustBeFilled
        }
        
        guard StringUtil.shared.isNumericOnly(cardNumber), StringUtil.shared.isNumericOnly(positionOnCard) else { return ValidationError.onlyNumericCharactersIsAllowed }
        
        guard cardNumber.count >= 2, positionOnCard.count > 0 else {
            return ValidationError.invalidInputFormat
        }
        
        return nil
    }
}
