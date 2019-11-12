//
//  UpcomingBillsViewModelTableViewCell.swift
//  Cheq
//
//  Created by Xuwei Liang on 6/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class UpcomingBillsTableViewCell: CTableViewCell {
    
    static let upcomingBillsCollectionView = 1
    @IBOutlet weak var containerView: UIView! 
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewModel = UpcomingBillsTableViewCellViewModel()
        self.collectionView.register(UINib(nibName: "UpcomingBillCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "UpcomingBillCollectionViewCell")
        setupConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setupConfig() {
        
        self.backgroundColor = .clear 
        let vm = self.viewModel as! UpcomingBillsTableViewCellViewModel
//        self.collectionViewHeight.constant = vm.cellHeight
        self.collectionView.delegate = vm
        self.collectionView.dataSource = vm
        self.collectionView.reloadData()
        
    }
}
