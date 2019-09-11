//
//  UICollectionView_Extension.swift
//  Cheq
//
//  Created by Xuwei Liang on 10/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

extension UICollectionView {
    func snapToCell(_ view: UIView) {
        guard let indexPath = closestCellToCenter(view) else { return }
        self.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func closestCellToCenter(_ view: UIView)->IndexPath? {
        let center = self.center
        let indexPath = self.indexPathForItem(at: view.convert(center, to: self)) ?? nil
        return indexPath
    }
}
