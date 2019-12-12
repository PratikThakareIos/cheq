//
//  UpcomingBillsViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 6/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 ViewModel for **UpcomingBillsTableViewCell**
 */
class UpcomingBillsTableViewCellViewModel: NSObject, TableViewCellViewModelProtocol, UICollectionViewDelegate, UICollectionViewDataSource {
    
    /// reuse identifier, this maps to the same String as on corresponding **xib**
    var identifier = "UpcomingBillsTableViewCell"

    /// **UpcomingBillsTableViewCell** is a horizontally scrollable collection view, so we need a list of upcoming bills
    var upcomingBills = [UpcomingBillCollectionViewCellViewModel]()
    
    /// automatic height calculation for collection view cell is a bit complicated, we use  height proportional to screen height instead
    var cellHeight = AppConfig.shared.screenHeight() * 0.3
    
    /// number of items in section view is based on **upcomingBills** Array
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return upcomingBills.count
    }
    
    /// cellForItemAt is where the cell is setup, when we updated **upcomingBills** and refresh collectionView, this method is called 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let upcomingBill: UpcomingBillCollectionViewCellViewModel = upcomingBills[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: upcomingBill.identifier, for: indexPath) as! UpcomingBillCollectionViewCell
        
        // popular data for cell
        cell.viewModel = upcomingBills[indexPath.row]
        cell.setupUI()
        
        return cell
    }
}
