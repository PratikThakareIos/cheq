//
//  SwipeToConfirmTableViewCell.swift
//  Cheq
//
//  Created by Xuwei Liang on 15/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 SwipeToConfirmTableViewCell is a tableview cell that implements the "swipe to confirm" widget for the lending stage of the app
 */
class SwipeToConfirmTableViewCell: CTableViewCell {
    
    /// refer to **xib**
    @IBOutlet weak var draggable: UIView!
    
    /// refer to **xib**
    @IBOutlet weak var backgroundTextContainerView: UIView!
    
    /// refer to **xib**
    @IBOutlet weak var backgroundText: CLabel!
    
    /// refer to **xib**
    @IBOutlet weak var draggableText: CLabel!
    
    /// refer to **xib**
    @IBOutlet weak var footerText: CLabel!
    
    /// refer to **xib**
    @IBOutlet weak var containerView: UIView!
    
    /// draggableOrigin is the variable for origin of draggable view. This variable gets updated as **drag** callback returns the position of the user's drag with finger. Check how it's updated
    var draggableOrigin: CGPoint = CGPoint.zero
    
    /// draggableOrigin is the variable for origin of draggable view. This variable gets updated as **drag** callback returns the position of the user's drag with finger.
    var draggableCenter: CGPoint = CGPoint.zero
    
    /// Initialization code
    override func awakeFromNib() {
        super.awakeFromNib()
        
        /// viewModel is initialised as **SwipeToConfirmTableViewCellViewModel**, to use it in **setupConfig** we still need to cast it from **TableViewCellViewModelProtocol** to **SwipeToConfirmTableViewCellViewModel**
        self.viewModel = SwipeToConfirmTableViewCellViewModel()
        self.setupConfig()
        
        /// Register to observe certain events. Events can be observed by anything from Singleton, View, ViewController and even TableView Cells.
        self.registerObservables()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /// event with **UINotificationEvent.swipeReset** will trigger **swipeReset** method
    func registerObservables() {
        NotificationCenter.default.addObserver(self, selector: #selector(swipeReset(_:)), name: NSNotification.Name(UINotificationEvent.swipeReset.rawValue), object: nil)
    }
    
    /// method to update the styling whenever viewModel is updated
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
        
        /// leveraging on Apple's **UIPanGestureRecognizer** to implement draggable logics
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(drag(_:)))
        self.draggable.addGestureRecognizer(panGestureRecognizer)
        self.draggableCenter = draggable.center
        self.draggableOrigin = draggable.center
    }
    
    /// resets the swipe button, if the user didn't drag all the way, the swipe button resets to the start
    @objc func swipeReset(_ notification: NSNotification) {
        UIView.animate(withDuration: 0.5) {
            self.draggable.center = self.draggableOrigin
            self.backgroundText.alpha = 1.0
            AppData.shared.acceptedAgreement = false
        }
    }
    
    /**
     This is a callback from **UIPanGestureRecognizer**
     We always update the draggable with new positions based on **gestureRecognizer.translation**.
     Ensure that translation is also reset time through the logic **gestureRecognizer.setTranslation(CGPoint.zero, in: draggableViewContainer)**
     Otherwise, we will have accumulated translation tracked in **gestureRecognizer**
    */
    @objc func drag(_ gestureRecognizer : UIPanGestureRecognizer) {
        LoggingUtil.shared.cPrint("drag")
        guard gestureRecognizer.view != nil else { return }
        guard let draggableView = gestureRecognizer.view else { return }
        guard let draggableViewContainer = draggableView.superview else { return }
        
        let translation = gestureRecognizer.translation(in: draggableViewContainer)
        if gestureRecognizer.state == .began {
            self.draggableCenter = draggableView.center
        }
        if gestureRecognizer.state == .changed {
            LoggingUtil.shared.cPrint("translation x - \(translation.x)")
            let newCenter = CGPoint(x: self.draggableCenter.x + translation.x, y: self.draggableCenter.y)
            self.draggableCenter = newCenter
            self.draggable.center = draggableCenter
            gestureRecognizer.setTranslation(CGPoint.zero, in: draggableViewContainer)
            edgeDetection(draggableView, draggableViewContainer: draggableViewContainer)
        }
    }
    
    /// inside the **drag** callback method, **edgeDetection** is always called to avoid the draggable button to go outside our containerView for the drag area
    func edgeDetection(_ draggableView: UIView, draggableViewContainer: UIView) {
        let rightEdge = draggableView.center.x + draggableView.frame.size.width/2
        let leftEdge = draggableView.center.x - draggableView.frame.size.width/2
    
        if rightEdge >= draggableViewContainer.frame.width {
            LoggingUtil.shared.cPrint("right edge reached")
            draggableView.center = CGPoint(x: draggableViewContainer.frame.width - draggableView.frame.width/2 - 10, y: draggableView.center.y)
            NotificationUtil.shared.notify(UINotificationEvent.swipeConfirmation.rawValue, key: "", value: "")
        }
        
        if leftEdge <= 0 {
            LoggingUtil.shared.cPrint("left edge reached")
            draggableView.center = CGPoint(x: draggableView.frame.width/2 + 10, y: draggableView.center.y)
        }
        
        self.backgroundText.alpha = 1 - (leftEdge / draggable.frame.width)
    }
}
