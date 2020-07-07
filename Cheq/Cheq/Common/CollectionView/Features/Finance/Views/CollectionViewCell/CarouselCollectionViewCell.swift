//
//  CarouselCollectionView.swift
//  CheqDemo
//
//  Created by XUWEI LIANG on 8/8/19.
//  Copyright © 2019 WiseTree Solutions Pty Ltd. All rights reserved.
//

import UIKit
import Charts

class CarouselCollectionViewCell: UICollectionViewCell {

    var currentTheme = sharedAppConfig.activeTheme
    var barView = CBarChartView()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.layer.masksToBounds = false
        setupChart()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupGradientIfNeeded()
    }
}

// MARK: ChartCollectionViewCellProtocol
extension CarouselCollectionViewCell: ChartCollectionViewCellProtocol {

    // placeholder for compact trait size customisation
    static var compactSize: CGSize {
        let theme = sharedAppConfig.activeTheme
        return CGSize(width: UIScreen.main.bounds.width * theme.carouselCellWidthToScreenRatio , height: UIScreen.main.bounds.height * theme.carouselCellHeightToScreenRatio)
    }

    // placeholder for "regular" trait size customisation
    // leave the setting
    static var regularSize: CGSize {
        return compactSize
    }

    // placeholder for "any" trait size customisation
    static var anySize: CGSize {
        return compactSize
    }

    func setupChart() {
        self.barView = CBarChartView(frame: self.contentView.frame)
        self.contentView.addSubview(barView)
        AutoLayoutUtil.pinToSuperview(self.barView, padding: 0.0)
    }

    fileprivate func refreshGradientColor() {
        if gradientLayerExist() {
            let gradLayer: CAGradientLayer = self.contentView.layer.sublayers?.first as! CAGradientLayer
            gradLayer.colors = ColorUtil.randGradientSet().map({ $0.cgColor })
        }
    }

    func refreshIfThemeUpdated() {
        if currentTheme.themeTitle != sharedAppConfig.activeTheme.themeTitle {
            self.currentTheme = sharedAppConfig.activeTheme
            self.refreshGradientColor()
        }
    }

    fileprivate func gradientLayerExist()-> Bool {
        let bottomLayer = self.contentView.layer.sublayers?.first
        return bottomLayer is CAGradientLayer
    }

    fileprivate func setupGradientIfNeeded() {
        if !gradientLayerExist() {
            addNewGradient()
        }
    }

    fileprivate func addNewGradient() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        sharedAppConfig.activeTheme.cardStyling(self.contentView, bgColors: ColorUtil.randGradientSet())
        CATransaction.commit()
    }

    func animate() {
        self.barView.animate(yAxisDuration: sharedAppConfig.activeTheme.mediumAnimationDuration, easingOption: .easeInOutBounce)
    }
}
