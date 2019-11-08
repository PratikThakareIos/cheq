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
    var upcomingBills = [GetUpcomingBillResponse]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return upcomingBills.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
}
