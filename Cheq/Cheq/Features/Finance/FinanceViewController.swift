//
//  FinanceViewController.swift
//  CheqDemo
//
//  Created by XUWEI LIANG on 7/8/19.
//  Copyright © 2019 WiseTree Solutions Pty Ltd. All rights reserved.
//

import UIKit
import PopOverMenu
import NavigationDropdownMenu

class FinanceViewController: UIViewController {

    var carouselCollectionViewCell: CarouselCollectionViewCell!
    var gridCollectionViewCell: GridCollectionViewCell!
    @IBOutlet var carouselCollectionView: UICollectionView!
    @IBOutlet var gridCollectionView: UICollectionView!
    @IBOutlet var pageControl: UIPageControl!
    var viewModel = FinanceViewModel("Expenses")
    //placeholder to avoid optional, since we definitely know we will get them after viewModel loaded
    var carouselCoordintor = CarouselCollectionViewCoordinator(CarouselCoordinatorViewModel())
    var gridCoordinator = GridCollectionViewCoordinator(GridCoordinatorViewModel())

    var menuView: NavigationDropdownMenu?
    var menuTitles = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.title
        self.menuTitles = self.buildMenuTitles()
        self.carouselCoordintor = CarouselCollectionViewCoordinator(self.viewModel.carouselCoordViewModel)
        self.gridCoordinator = GridCollectionViewCoordinator(self.viewModel.gridCoordViewModel)
        self.pageControl.isUserInteractionEnabled = false
        self.setupCollectionView()
        self.menuView = NavigationDropdownMenu(title: Title.index(0), items: self.menuTitles)
        self.setupDropdown()
        self.loadData { self.reloadUI() }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func reloadUI() {
        self.navigationController?.navigationBar.barStyle = sharedAppConfig.activeTheme.barStyle
        self.tabBarController?.tabBar.barStyle = sharedAppConfig.activeTheme.barStyle
        self.view.backgroundColor = sharedAppConfig.activeTheme.backgroundColor
        self.carouselCollectionView.collectionViewLayout.invalidateLayout()
        self.gridCollectionView.collectionViewLayout.invalidateLayout()
        self.carouselCollectionView.reloadData()
        self.gridCollectionView.reloadData()
    }

    func buildMenuTitles()->[String] {
        return FinancialPeriod.allStringValues.map{ String("\($0) Expenses") }
    }

    func setupCollectionView() {

        if let carouselFlowLayout = self.carouselCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            carouselFlowLayout.estimatedItemSize = CarouselCollectionViewCell.suitableSize(self.traitCollection)
            self.carouselCollectionView.collectionViewLayout = carouselFlowLayout
        }

        if let gridFlowLayout = self.gridCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            gridFlowLayout.estimatedItemSize = GridCollectionViewCell.suitableSize(self.traitCollection)
            self.gridCollectionView.collectionViewLayout = gridFlowLayout
        }
        
        self.carouselCoordintor.carouselDelegate = self
        self.carouselCoordintor.controllerView = self.view
        self.carouselCoordintor.collectionView = self.carouselCollectionView
        self.carouselCollectionView.delegate = self.carouselCoordintor
        self.carouselCollectionView.dataSource = self.carouselCoordintor
        self.gridCoordinator.collectionView = self.gridCollectionView
        self.gridCollectionView.delegate = self.gridCoordinator
        self.gridCollectionView.dataSource = self.gridCoordinator
        setupCollectionViewPadding()
    }

    func setupCollectionViewPadding() {
        let carouselCellSize = CarouselCollectionViewCell.suitableSize(self.traitCollection)
        let gridCellSize = GridCollectionViewCell.suitableSize(self.traitCollection)
        sharedAppConfig.activeTheme.collectionViewPadding(self.carouselCollectionView, cellLength: carouselCellSize.width, collectionType: .carousel)
        sharedAppConfig.activeTheme.collectionViewPadding(self.gridCollectionView, cellLength: gridCellSize.width, collectionType: .grid)
    }

    func setupDropdown() {
        guard let menuView = menuView else { return }
        menuView.arrowTintColor = sharedAppConfig.activeTheme.linksColor
        menuView.navigationBarTitleFont = sharedAppConfig.activeTheme.mediumFont
        menuView.cellTextLabelColor = sharedAppConfig.activeTheme.textColor
        menuView.cellTextLabelFont = sharedAppConfig.activeTheme.defaultFont
        menuView.menuTitleColor = sharedAppConfig.activeTheme.textColor
        menuView.cellBackgroundColor = sharedAppConfig.activeTheme.backgroundColor
        menuView.cellSeparatorColor = sharedAppConfig.activeTheme.textColor
        self.navigationItem.titleView = menuView
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            self.loadData {}
        }
    }

    func loadData(_ completion: @escaping ()-> Void) {
        sharedAppConfig.showSpinner()
        self.viewModel.load {
            sharedAppConfig.hideSpinner()
            self.pageControl.numberOfPages = self.viewModel.carouselCoordViewModel.barChartModels.count
            completion()
        }
    }
}

// MARK: CarouselCollectionViewCoordinatorDelegate
extension FinanceViewController: CarouselCollectionViewCoordinatorDelegate {
    func updatePaginControl(_ index: Int) {
        self.pageControl.currentPage = index
    }
}

// MARK: ChartCollectionViewCoordinatorDelegate
extension FinanceViewController {
    @IBAction func switchThemeMenu(_ sender: UIBarButtonItem) {
        let titles = sharedAppConfig.themeTitles
        let popOverViewController = PopOverViewController.instantiate()
        popOverViewController.set(titles: titles)
        popOverViewController.popoverPresentationController?.barButtonItem = sender
        let height = CGFloat(titles.count) * sharedAppConfig.activeTheme.popoverMenuLabelHeight + sharedAppConfig.activeTheme.padding
        popOverViewController.preferredContentSize = CGSize(width: UIScreen.main.bounds.width*sharedAppConfig.activeTheme.popoverMenuToScreenWidthRatio, height: height)
        popOverViewController.presentationController?.delegate = self
        popOverViewController.completionHandler = { selectRow in
            self.switchTheme(selectRow)
        }
        present(popOverViewController, animated: true, completion: nil)
    }

    func switchTheme(_ index: Int) {
        sharedAppConfig.switchTheme(index)
        self.reloadUI()
        self.setupDropdown()
    }
}

extension FinanceViewController: UIAdaptivePresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }


    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}



