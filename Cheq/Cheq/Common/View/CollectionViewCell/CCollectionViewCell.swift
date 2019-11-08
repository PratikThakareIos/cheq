//
//  CCollectionViewCell.swift
//  Cheq
//
//  Created by Xuwei Liang on 8/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

protocol CCollectionViewCellProtocol {
    func setupConfig()
}

class CCollectionViewCell: UICollectionViewCell, CCollectionViewCellProtocol {
    func setupUI() { }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupConfig() {
        // subclass needs to override
    }
    
    var viewModel: CollectionViewCellViewModelProtocol?
}
