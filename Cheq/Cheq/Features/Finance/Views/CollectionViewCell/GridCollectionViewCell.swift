//
//  GridCollectionViewCell.swift
//  CheqDemo
//
//  Created by XUWEI LIANG on 8/8/19.
//  Copyright © 2019 WiseTree Solutions Pty Ltd. All rights reserved.
//

import UIKit
import Charts

class GridCollectionViewCell: UICollectionViewCell {

    var pie = CPieChartView()
    @IBOutlet var title: UILabel! 

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.layer.masksToBounds = false
        self.setupChart()
        self.setupTitleText()
    }

    func setupTitleText() {
        self.title.textColor = sharedAppConfig.activeTheme.textColor
        self.title.font = sharedAppConfig.activeTheme.defaultFont
        self.contentView.bringSubviewToFront(self.title)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // add gradient once here, it is too early on awakeFromNib
        if !(self.contentView.layer.sublayers?.first is CAGradientLayer) {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            sharedAppConfig.activeTheme.cardStyling(self.contentView, bgColor: sharedAppConfig.activeTheme.textBackgroundColor)
            CATransaction.commit()
        }
    }
}

// MARK: ChartCollectionViewCellProtocol
extension GridCollectionViewCell: ChartCollectionViewCellProtocol {
    
    static var compactSize: CGSize {
        let theme = sharedAppConfig.activeTheme
        return CGSize(width: UIScreen.main.bounds.width * theme.gridCellToScreenRatio, height: UIScreen.main.bounds.width * theme.gridCellToScreenRatio)
    }

    static var regularSize: CGSize {
        return compactSize
    }

    static var anySize: CGSize {
        return compactSize
    }

    func setupChart() {
        self.pie = CPieChartView(frame: self.contentView.frame)
        self.contentView.addSubview(pie)
        AutoLayoutUtil.pinToSuperview(pie, padding: 0.0)
    }

    func animate() {
        self.pie.animate(yAxisDuration: sharedAppConfig.activeTheme.mediumAnimationDuration, easingOption: .easeInOutBounce)
    }
}
