//
//  UIlable_extension.swift
//  Cheq
//
//  Created by Amit.Rawal on 27/05/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {

    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {

        guard let labelText = self.text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        paragraphStyle.alignment = .center

        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

        // (Swift 4.2 and above) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))


        // (Swift 4.1 and 4.0) Line spacing attribute
       // attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        self.attributedText = attributedString
    }
}



//let label = UILabel()
//let stringValue = "Set\nUILabel\nline\nspacing"
//
//// Pass value for any one argument - lineSpacing or lineHeightMultiple
//label.setLineSpacing(lineSpacing: 2.0) .  // try values 1.0 to 5.0
//
//// or try lineHeightMultiple
////label.setLineSpacing(lineHeightMultiple = 2.0) // try values 0.5 to 2.0
