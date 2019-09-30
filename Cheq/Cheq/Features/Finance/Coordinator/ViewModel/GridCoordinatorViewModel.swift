//
//  GridCellVewModel.swift
//  CheqDemo
//
//  Created by XUWEI LIANG on 10/8/19.
//  Copyright © 2019 WiseTree Solutions Pty Ltd. All rights reserved.
//

import UIKit

class GridCoordinatorViewModel: BaseViewModel {

    var pieChartModels: [CChartModel] = []

    override init() {
        super.init()
    }

    override func load(_ complete: @escaping () -> Void) {
        // load data for grid
        self.pieChartModels = ChartModelUtil.fakePieChartModel()
        complete()
    }
}
