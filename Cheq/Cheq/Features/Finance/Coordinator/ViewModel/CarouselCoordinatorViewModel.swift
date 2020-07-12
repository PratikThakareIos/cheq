//
//  CarouselCellViewModel.swift
//  CheqDemo
//
//  Created by XUWEI LIANG on 10/8/19.
//  Copyright © 2019 WiseTree Solutions Pty Ltd. All rights reserved.
//

import UIKit

class CarouselCoordinatorViewModel: BaseViewModel {

    var barChartModels: [CChartModel] = []

    override init() {
        super.init()
    }

    // load data for carousel
    override func load(_ complete: @escaping () -> Void) {
        self.barChartModels = ChartModelUtil.fakeBarChartModel(4)
        complete()
    }
}
