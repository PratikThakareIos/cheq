//
//  String_Extension.swift
//  Cheq
//
//  Created by Xuwei Liang on 26/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

extension String {
    
    /// If string value is html, this method will convert the html into rendered NSAttributedString based on the html markup
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    /// converts html to String instead of NSAttributedString 
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
