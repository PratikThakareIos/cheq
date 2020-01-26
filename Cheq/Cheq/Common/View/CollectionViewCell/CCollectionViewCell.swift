//
//  CCollectionViewCell.swift
//  Cheq
//
//  Created by Xuwei Liang on 8/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 CCollectionViewCellProtocol defines the methods which collection view cell needs to implement
 */
protocol CCollectionViewCellProtocol {
    
    /// this method should be implemented
    func setupConfig()
}

/**
Some UI pattern requires horizontally scrollable components on tableview cell, for these UI pattern, we implement **CCollectionViewCell** and CollectionView inside a **CTableViewCell**
*/
class CCollectionViewCell: UICollectionViewCell, CCollectionViewCellProtocol {
    
    /// empty implementation, should be override by subclasses
    func setupUI() { }
    
    /// called when initialise by nib 
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /// subclass needs to override
    func setupConfig() {
        
    }
    
    /// viewModel must conforms to **CollectionViewCellViewModelProtocol**
    var viewModel: CollectionViewCellViewModelProtocol?
}
