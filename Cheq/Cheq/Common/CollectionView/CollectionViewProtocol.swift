//
//  CollectionViewProtocol.swift
//  CheqDemo
//
//  Created by XUWEI LIANG on 8/8/19.
//  Copyright © 2019 WiseTree Solutions Pty Ltd. All rights reserved.
//

import UIKit

enum CollectionViewIdentifier: String {
    case CarouselCollectionView = "CarouselCollectionView"
    case GridCollectionView = "GridCollectionView"
}

protocol ChartCollectionViewCoordinatorDelegate {
    func selectedCell(_ indexPath: IndexPath, collectionView: UICollectionView)
}
