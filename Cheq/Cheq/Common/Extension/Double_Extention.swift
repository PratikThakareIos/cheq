//
//  Double_Extention.swift
//  Cheq
//
//  Created by Manish.D on 08/04/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import Foundation

//How to use -

//let number = 31908551587.0
//print(number.strWithCommas) // "31,90,85,51,587"

extension Double {
    private static var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSize = 3
        numberFormatter.secondaryGroupingSize = 3
        return numberFormatter
    }()

    var strWithCommas: String {
        return Double.numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}

extension Double {
    
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func round() -> Double {
           let divisor = pow(10.0, Double(2))
           return (self * divisor).rounded() / divisor
    }
}

extension Int {
    
    private static var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSize = 3
        numberFormatter.secondaryGroupingSize = 3
        return numberFormatter
    }()

    var strWithCommas: String {
        return Int.numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}




