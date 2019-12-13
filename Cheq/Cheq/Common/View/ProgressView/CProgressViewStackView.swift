//
//  CProgressView.swift
//  Cheq
//
//  Created by Xuwei Liang on 23/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 During **Onboarding** flow, there is multiple progress bars which are displayed on navigation bar titleview. **CProgressViewStackView** is a container to hold the logics to align multiple progress bars together using a horizontal stackview. The variable **progressViews** holds an Array of **CProgressView** which is a the view class for progress bar implementation.
 */
class CProgressViewStackView: UIStackView {
    
    /// progessViews holds the actual **CProgressView** which we want to update during **Onboarding** flow
    var progressViews: [CProgressView] = []
    
    /// custom init method taking in multiple **progressViews**
    init(progressViews: [CProgressView]) {
        super.init(frame: CGRect.zero)
        self.progressViews = progressViews
        setupConfig()
    }
    
    /// adding **setupConfig** to default init method by frame
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfig()
    }
    
    /// adding **setupConfig** to default init method by coder
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupConfig()
    }
    
    /// setting up the layout for **CProgressViewStackView**.
    func setupConfig() {
        self.distribution = .fill
        self.alignment = .center
        self.axis = .horizontal
        self.backgroundColor = .green
        self.spacing = 10.0
        self.backgroundColor = .red 
        for progressView in self.progressViews {
            
            /// AddArrangedSubview inserts progressView, stackview automatically applies its  autolayout constraints, so it saves alot of work doing autolayout automatically.
            self.addArrangedSubview(progressView)
        }
    }
    
    /// **setProgress** allows progress amount to be set on a particular **CProgressView** from **CProgressStackView** level. This helper abstracts the needs to extract each progress bar out before updating. 
    func setProgress(_ index: Int, progress: Float) {
        guard self.progressViews.isEmpty == false, index >= 0, index < self.progressViews.count else { return }
        let progressView: UIProgressView = self.progressViews[index]
        progressView.setProgress(progress, animated: false)
    }

}
