//
//  CPopupView.swift
//  Cheq
//
//  Created by Xuwei Liang on 14/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import SwiftEntryKit

class CPopupView {
    
    var customView: UIView?
    
    init(_ customView: UIView) {
        self.customView = customView
    }
    
    class func dismiss() {
        if SwiftEntryKit.isCurrentlyDisplaying {
            SwiftEntryKit.dismiss()
        }
    }
    
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
