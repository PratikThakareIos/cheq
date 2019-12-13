//
//  CPopupView.swift
//  Cheq
//
//  Created by Xuwei Liang on 14/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import SwiftEntryKit

/**
 This is wrapper to whichever popup implementation that the app uses. It abtracts the details of implementation, so that if **SwiftEntryKit** is replaced with something else, **CPopupView**  are still sharing the same interface for popup with the rest of the code.
 */
class CPopupView {
    
    /// Variable instance for customView
    var customView: UIView?
    
    /// Custom init to take customView if we need it
    init(_ customView: UIView) {
        self.customView = customView
    }
    
    /// Dismiss method hides the details on how we implement dismissal for the outside world
    class func dismiss() {
        if SwiftEntryKit.isCurrentlyDisplaying {
            SwiftEntryKit.dismiss()
        }
    }
    
    /// Show method hides all the details required to setup the popup modal, the details can change based on the implmentation and library which we use. But to the outside world, **show** method will remain the interface to display a popup with the **customView** provided during initialisation. 
    func show() {
        
        if SwiftEntryKit.isCurrentlyDisplaying { return }
        
        guard let view = customView else { return }
        view.translatesAutoresizingMaskIntoConstraints = false
        var attributes = EKAttributes.bottomFloat
        attributes.entranceAnimation = .translation
        attributes.position = .bottom
        attributes.popBehavior = .animated(animation: .translation)
        attributes.entryInteraction = .dismiss
        attributes.screenInteraction = .dismiss
        attributes.windowLevel = .normal
        attributes.scroll = .disabled
        attributes.entryBackground = .clear
        let dimmed = UIColor.black.withAlphaComponent(AppConfig.shared.activeTheme.nonActiveAlpha)
        attributes.screenBackground = .color(color: .init(dimmed))
        attributes.displayDuration = .infinity
        attributes.shadow = .none
        attributes.roundCorners = .all(radius: AppConfig.shared.activeTheme.defaultCornerRadius)
        attributes.border = .value(color: .clear, width: 1.0)
        attributes.positionConstraints = .fullWidth
        SwiftEntryKit.display(entry: view, using: attributes)
    }
}
