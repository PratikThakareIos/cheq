//
//  CTableViewControllerProtocol.swift
//  Cheq
//
//  Created by Xuwei Liang on 19/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class CTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: BaseTableVCViewModel = BaseTableVCViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.tableView.estimatedRowHeight = 1
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorStyle = .none
        self.registerCells()
    }
    
    func setupDelegate() {
        guard self.tableView != nil else { return }
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}

extension CTableViewController {
    // handle notification to trigger reload of table
    @objc func reloadTableLayout(_ notification: NSNotification) {
        let _ = notification.userInfo?[NotificationUserInfoKey.cell.rawValue]
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    @objc func reloadTable(_ notification: NSNotification) {
        let _ = notification.userInfo?[NotificationUserInfoKey.cell.rawValue]
        self.tableView.reloadData()
    }
    
    
}

extension CTableViewController {
    @objc func registerCells() {
        // to be override by subclasses
    }
}

extension CTableViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section: TableSectionViewModel = self.viewModel.sections[section]
        return section.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // setup cell
        let section: TableSectionViewModel = self.viewModel.sections[indexPath.section]
        let cellViewModel: TableViewCellViewModelProtocol = section.rows[indexPath.row]
        let cell: CTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellViewModel.identifier, for: indexPath) as! CTableViewCell
        cell.viewModel = cellViewModel
        cell.setupConfig()
        return cell
    }
}

extension CTableViewController {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // supporting upcomingBillsCollectionView
        if collectionView.tag == UpcomingBillsTableViewCell.upcomingBillsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            cell.backgroundColor = .red
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
}
