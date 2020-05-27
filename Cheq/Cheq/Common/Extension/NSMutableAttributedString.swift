//
//  NSAttributedString.swift
//  Cheq
//
//  Created by XUWEI LIANG on 10/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 extension to NSMutableAttributedString
 */
extension NSMutableAttributedString {

    /// Apply styling to link amongst text. Find the text amongst current NSMutableAttributedString's value and and apply link, color and font styling.
    func applyLinkTo(_ text: String, link: String, color: UIColor, font: UIFont) {
        let mainString = self.string as NSString
        let range = mainString.range(of: text)
        if range.location != NSNotFound {
            self.addAttribute(.link, value: link, range: range)
            self.addAttribute(.foregroundColor, value: color , range: range)
            self.addAttribute(.font, value: font, range: range )
        }
    }
    
    /// Simply apply highlight, but no link to a given text
    func applyHighlight(_ text: String, color: UIColor, font: UIFont) {
        let mainString = self.string as NSString
        let range = mainString.range(of: text)
        if range.location != NSNotFound {
            self.addAttribute(.foregroundColor, value: color , range: range)
            self.addAttribute(.font, value: font, range: range )
        }
    }
    
    /// Simply apply highlight, but no link to a given text
    func applyHighlightTwo(text1: String,text2: String, color: UIColor, font: UIFont) {
        let mainString = self.string as NSString
        
        let range = mainString.range(of: text1)
        if range.location != NSNotFound {
            self.addAttribute(.foregroundColor, value: color , range: range)
            self.addAttribute(.font, value: font, range: range )
        }
        
        let range2 = mainString.range(of: text2)
        if range2.location != NSNotFound {
            self.addAttribute(.foregroundColor, value: color , range: range2)
            self.addAttribute(.font, value: font, range: range2 )
        }
    }

}
