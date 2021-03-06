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
        //setupKeyboardHandling()
        setupDelegate()
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        benefitsCollectionView.snapToCell(self.view)
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
        AppConfig.shared.markFirstInstall()
        let storyboard = UIStoryboard(name: StoryboardName.onboarding.rawValue, bundle: Bundle.main)
        let regViewController = storyboard.instantiateViewController(withIdentifier: OnboardingStoryboardId.registration.rawValue) as! RegistrationVC
        let nav = UINavigationController(rootViewController: regViewController)
        nav.modalPresentationStyle = .fullScreen
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
            AppConfig.shared.activeTheme.headerBoldFont
        cell.title.textColor = benefit.textColor
        cell.caption.font = AppConfig.shared.activeTheme.defaultFont
        cell.caption.textColor = benefit.textColor
        cell.bgView.backgroundColor = .clear
        cell.emoji.image = UIImage.init(named: benefit.imageName)
        let _ = ViewUtil.shared.applyViewGradient(cell.contentView, startingColor: benefit.gradientColors[0], endColor: benefit.gradientColors[1])
        AppConfig.shared.activeTheme.cardStyling(cell.contentView, addBorder: false)
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
