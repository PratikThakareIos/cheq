//
//  CTableViewControllerProtocol.swift
//  Cheq
//
//  Created by Xuwei Liang on 19/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class CTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    
    @objc func categoryById(_ notification: NSNotification) {
        guard let categoryId = notification.userInfo?["id"] as? String else { return }
        guard let id = Int(categoryId) else { return }
        AppData.shared.selectedCategoryId = id
        // app nav to category id
        let vc = AppNav.shared.initViewController(StoryboardName.main.rawValue, storyboardId: MainStoryboardId.spendingCategoryById.rawValue, embedInNav: false)
        AppNav.shared.pushToViewController(vc, from: self)
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
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let cellViewModel: TableViewCellViewModelProtocol = self.viewModel.sections[indexPath.section].rows[indexPath.row]
//        let cell: CTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellViewModel.identifier, for: indexPath) as! CTableViewCell
//        cell.alpha = 0.0
//        UIView.animate(withDuration: AppConfig.shared.activeTheme.mediumAnimationDuration) {
//            cell.alpha = 1.0
//        }
//    }
}

//extension CTableViewController {
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        // supporting upcomingBillsCollectionView
//        if collectionView.tag == UpcomingBillsTableViewCell.upcomingBillsCollectionView {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
//            cell.backgroundColor = .red
//            return cell
//        }
//        return UICollectionViewCell()
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 10
//    }
//}
