//
//  GridCollectionViewCoordinator.swift
//  CheqDemo
//
//  Created by XUWEI LIANG on 8/8/19.
//  Copyright © 2019 WiseTree Solutions Pty Ltd. All rights reserved.
//

import UIKit

// MARK: UICollectionViewDelegate, UICollectionViewDataSource
class GridCollectionViewCoordinator: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {

    let theme = sharedAppConfig.activeTheme
    var collectionView: UICollectionView?
    var delegate: ChartCollectionViewCoordinatorDelegate?
    var viewModel: GridCoordinatorViewModel

    init(_ viewModel: GridCoordinatorViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pieChartModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = String(describing: GridCollectionViewCell.self)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? GridCollectionViewCell
        let chartModel = viewModel.pieChartModels[indexPath.row]
        cell?.pie.loadData(chartModel)
        let amount = chartModel.dataSet["amount"] as! String
        cell?.title.text = "\(amount)"
        cell?.title.textColor = sharedAppConfig.activeTheme.textColor
        return cell ?? UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sharedAppConfig.activeTheme.padding
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        let chartCell = cell as! ChartCollectionViewCellProtocol
        chartCell.animate()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if delegate != nil { delegate?.selectedCell(indexPath, collectionView: collectionView) }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: theme.padding, bottom: 0, right: theme.padding)
    }
}
