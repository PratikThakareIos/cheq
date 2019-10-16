//
//  SwipeToConfirmTableViewCell.swift
//  Cheq
//
//  Created by Xuwei Liang on 15/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class SwipeToConfirmTableViewCell: CTableViewCell {
    
    @IBOutlet weak var draggable: UIView!
    @IBOutlet weak var backgroundTextContainerView: UIView!
    @IBOutlet weak var backgroundText: CLabel!
    @IBOutlet weak var draggableText: CLabel!
    @IBOutlet weak var footerText: CLabel!
    @IBOutlet weak var containerView: UIView!
//    let panGestureRecognizer: UIPanGestureRecognizer =  UIPanGestureRecognizer(target: self, action: #selector(drag(_:)))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewModel = SwipeToConfirmTableViewCellViewModel()
        self.setupConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setupConfig() {
        self.backgroundColor = .clear
        let vm = self.viewModel as! SwipeToConfirmTableViewCellViewModel
        self.containerView.backgroundColor = .clear
        self.backgroundTextContainerView.backgroundColor = AppConfig.shared.activeTheme.primaryColor
        self.footerText.textColor = AppConfig.shared.activeTheme.lightestGrayColor
        self.backgroundText.text = vm.textInBackground
        self.backgroundText.textColor = AppConfig.shared.activeTheme.altTextColor
        self.footerText.text = vm.footerText
        self.draggableText.text = vm.buttonTitle
        self.draggableText.font = AppConfig.shared.activeTheme.mediumFont
        self.draggable.backgroundColor = AppConfig.shared.activeTheme.altTextColor
        AppConfig.shared.activeTheme.cardStyling(self.backgroundTextContainerView, addBorder: false)
        AppConfig.shared.activeTheme.cardStyling(self.draggable, addBorder: false)
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(drag(_:)))
        self.draggable.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func drag(_ gestureRecognizer : UIPanGestureRecognizer) {
        LoggingUtil.shared.cPrint("drag")
        guard gestureRecognizer.view != nil else { return }
        guard let draggableView = gestureRecognizer.view else { return }
        guard let draggableViewContainer = draggableView.superview else { return }
        var currentCenter: CGPoint = draggableView.center
        var translation = gestureRecognizer.translation(in: draggableViewContainer)
        switch gestureRecognizer.state {
        case .began:
            currentCenter = draggableView.center
            translation = gestureRecognizer.translation(in: draggableViewContainer)
        case .changed:
            draggableView.center = CGPoint(x: currentCenter.x + translation.x, y: currentCenter.y)
            let rightEdge = draggableView.center.x + draggableView.frame.size.width/2
            let leftEdge = draggableView.center.x - draggableView.frame.size.width/2
            if rightEdge >= draggableViewContainer.frame.width {
                LoggingUtil.shared.cPrint("right edge reached")
                draggableView.center = CGPoint(x: draggableViewContainer.frame.width - draggableView.frame.width/2 - 10, y: currentCenter.y)
                NotificationUtil.shared.notify(UINotificationEvent.swipeConfirmation.rawValue, key: "", value: "")
            }

            if leftEdge <= 0 {
                LoggingUtil.shared.cPrint("left edge reached")
                draggableView.center = CGPoint(x: draggableView.frame.width/2 + 10, y: currentCenter.y)
            }
        default: break
        }
    }
}
