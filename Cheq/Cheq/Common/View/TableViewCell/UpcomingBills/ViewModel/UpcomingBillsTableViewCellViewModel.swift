//
//  UpcomingBillsViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 6/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class UpcomingBillsTableViewCellViewModel: NSObject, TableViewCellViewModelProtocol, UICollectionViewDelegate, UICollectionViewDataSource {
    var identifier = "UpcomingBillsTableViewCell"

    var upcomingBills = [UpcomingBillCollectionViewCellViewModel]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return upcomingBills.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let upcomingBill: UpcomingBillCollectionViewCellViewModel = upcomingBills[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: upcomingBill.identifier, for: indexPath) as! UpcomingBillCollectionViewCell
        
        // popular data for cell
        cell.viewModel = upcomingBills[indexPath.row]
        cell.setupUI()
        
        return cell
    }
}
