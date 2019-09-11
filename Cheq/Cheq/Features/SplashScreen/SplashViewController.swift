//
//  MoneySoftLoginViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 3/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit
import NotificationCenter
import PopupDialog

class SplashViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var registrationButton: CButton!
    @IBOutlet weak var benefitsCollectionView: UICollectionView!
    let viewModel = SplashViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardHandling()
        setupDelegate()
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupDelegate() {
        self.scrollView.delegate = self
        self.benefitsCollectionView.delegate = self
        self.benefitsCollectionView.dataSource = self
    }
    
    func setupUI() {
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        benefitsCollectionView.backgroundColor = .clear
        guard var regButton = self.registrationButton else { return }
        regButton.backgroundColor = AppConfig.shared.activeTheme.primaryColor
        regButton.titleLabel?.font = AppConfig.shared.activeTheme.mediumFont
        ViewUtil.shared.circularButton(&regButton)
    }
}


// MARK: IBActions
extension SplashViewController {
    @IBAction func registration(_ sender: Any) {
        var current = pageControl.currentPage
        guard current == viewModel.benefitList.count - 1 else {
            current = current + 1
            self.benefitsCollectionView .scrollToItem(at: IndexPath(row: current, section: 0), at: .centeredHorizontally, animated: true)
            pageControl.currentPage = current
            return
        }
        let storyboard = UIStoryboard(name: StoryboardName.onboarding.rawValue, bundle: Bundle.main)
        let regViewController = storyboard.instantiateViewController(withIdentifier: StoryboardId.registration.rawValue) as! RegistrationViewController
        let nav = UINavigationController(rootViewController: regViewController)
        self.present(nav, animated: true)

    }
}

// MARK: UICollectionViewDataSource, UICollectionViewDelegate
extension SplashViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.benefitList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let benefit = viewModel.benefitList[indexPath.row]
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BenefitCollectionViewCell", for: indexPath) as! BenefitCollectionViewCell
        setupCellUI(&cell, benefit)
        return cell
    }
    
    func setupCellUI(_ cell: inout BenefitCollectionViewCell, _ benefit: Benefit) {
        cell.backgroundColor = .clear
        cell.title.text = benefit.title
        cell.caption.text = benefit.caption
        cell.title.font =
            AppConfig.shared.activeTheme.headerFont
        cell.title.textColor = AppConfig.shared.activeTheme.altTextColor
        cell.caption.font = AppConfig.shared.activeTheme.defaultFont
        cell.caption.textColor = AppConfig.shared.activeTheme.altTextColor
        cell.bgView.backgroundColor = .clear
        cell.emoji.image = UIImage.init(named: benefit.imageName)
        AppConfig.shared.activeTheme.cardStyling(cell.bgView, bgColor:  benefit.bgColor, applyShadow: false)
    }
}


// MARK: UIScrollViewDelegate
extension SplashViewController: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.isKind(of: UICollectionView.self) {
            let collectionView = scrollView as! UICollectionView
            collectionView.snapToCell(self.view)
            pageControl.currentPage = collectionView.closestCellToCenter(self.view)?.row ?? 0
        }
    }
}

// MARK: UIViewControllerProtocol
extension SplashViewController {
    @objc override func baseScrollView() -> UIScrollView? {
        return self.scrollView
    }
}
