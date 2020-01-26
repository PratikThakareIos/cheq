//
//  UpcomingBillsViewModelTableViewCell.swift
//  Cheq
//
//  Created by Xuwei Liang on 6/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 UpcomingBillsTableViewCell represents the horizontal scrolling list of upcoming bills
 */
class UpcomingBillsTableViewCell: CTableViewCell {
    
    /// keeping a number for tagging use, but not necessarily needed
    static let upcomingBillsCollectionView = 1
    
    /// containerView
    @IBOutlet weak var containerView: UIView!
    
    /// collectionView is used to implement the horizontal scroll
    @IBOutlet weak var collectionView: UICollectionView!
    
    /// height constraint that determine collectionView height
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
   
    /// called when init from **xib**
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewModel = UpcomingBillsTableViewCellViewModel()
        self.collectionView.register(UINib(nibName: "UpcomingBillCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "UpcomingBillCollectionViewCell")
        setupConfig()
    }

   /// Override this method to add custom logic when cell is selected. Alternatively add tap gesture to trigger a method that applies custom logic.
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /// call setupConfig after updated viewModel 
    override func setupConfig() {
        
        self.backgroundColor = .clear 
        let vm = self.viewModel as! UpcomingBillsTableViewCellViewModel
//        self.collectionViewHeight.constant = vm.cellHeight
        self.collectionView.delegate = vm
        self.collectionView.dataSource = vm
        self.collectionView.reloadData()
        
    }
}
