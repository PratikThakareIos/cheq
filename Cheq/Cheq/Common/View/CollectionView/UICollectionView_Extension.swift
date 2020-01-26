//
//  UICollectionView_Extension.swift
//  Cheq
//
//  Created by Xuwei Liang on 10/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 Extension helper methods for **UICollectionView**
 */
extension UICollectionView {
    
    /**
     When a collectionView is scrolling, and I pass in a reference view, this method calculates the nearest cell to the view and snap its horizontal centre to the horizontal centre of the view.
     - parameter view: reference view to check center against with
    */
    func snapToCell(_ view: UIView) {
        guard let indexPath = closestCellToCenter(view) else { return }
        self.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    /**
     Helper method to return the closest cell in collectionView to the given view
     - parameter view: reference view for finding closest cell 
    */
    func closestCellToCenter(_ view: UIView)->IndexPath? {
        let center = self.center
        let indexPath = self.indexPathForItem(at: view.convert(center, to: self)) ?? nil
        return indexPath
    }
}
