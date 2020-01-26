//
//  NSLayoutConstraint_Extension.swift
//  Cheq
//
//  Created by Xuwei Liang on 12/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    
    /// Extension method that allows programmatic modification of auto constraint multiplier attribute. We actually re-create a new auto constraint with new multiplier value. 
    func setMultiplier(multiplier:CGFloat) -> NSLayoutConstraint {
        NSLayoutConstraint.deactivate([self])
        
        let newConstraint = NSLayoutConstraint(
            item: firstItem as Any,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}
