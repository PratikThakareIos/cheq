//
//  CProgressView.swift
//  Cheq
//
//  Created by Xuwei Liang on 23/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class CProgressViewStackView: UIStackView {
    
    var progressViews: [CProgressView] = []
    
    init(progressViews: [CProgressView]) {
        super.init(frame: CGRect.zero)
        self.progressViews = progressViews
        setupConfig()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfig()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupConfig()
    }
    
    func setupConfig() {
        self.distribution = .fill
        self.alignment = .center
        self.axis = .horizontal
        self.backgroundColor = .green
        self.spacing = 10.0
        self.backgroundColor = .red 
        for progressView in self.progressViews {
            self.addArrangedSubview(progressView)
        }
    }
    
    func setProgress(_ index: Int, progress: Float) {
        guard self.progressViews.isEmpty == false, index >= 0, index < self.progressViews.count else { return }
        let progressView: UIProgressView = self.progressViews[index]
        progressView.setProgress(progress, animated: false)
    }

}
