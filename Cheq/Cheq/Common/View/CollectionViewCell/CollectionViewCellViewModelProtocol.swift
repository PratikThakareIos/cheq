//
//  CCollectionViewCellViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 8/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 CollectionViewCellViewModelProtocol also dictates that **identifier** variable must defined, so we know how to load up the view by identifier, this pattern is also applied for tableviewcells 
 */
protocol CollectionViewCellViewModelProtocol {
    var identifier: String { get }
}
