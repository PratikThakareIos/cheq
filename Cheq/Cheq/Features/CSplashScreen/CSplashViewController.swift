//
//  CSplashViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 20/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import Parchment

class CSplashViewController: UIViewController, PagingViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let budgetPage = CSplashPageViewModel()
        budgetPage.splashImage = .budget
        budgetPage.splashText = .budget
        budgetPage.bgColor = AppConfig.shared.activeTheme.splashBgColor1
        let budgetPageViewController = AppNav.shared.initViewController(StoryboardName.onboarding.rawValue, storyboardId: OnboardingStoryboardId.cSplashPage.rawValue, embedInNav: false) as! CSplashPageViewController
        budgetPageViewController.viewModel = budgetPage
        
        let spendingPage = CSplashPageViewModel()
        spendingPage.splashImage = .spending
        spendingPage.splashText = .spending
        spendingPage.bgColor = AppConfig.shared.activeTheme.splashBgColor2
        let spendingPageViewController = AppNav.shared.initViewController(StoryboardName.onboarding.rawValue, storyboardId: OnboardingStoryboardId.cSplashPage.rawValue, embedInNav: false) as! CSplashPageViewController
        spendingPageViewController.viewModel = spendingPage
        
        let cheqPayPage = CSplashPageViewModel()
        cheqPayPage.splashImage = .cheqpay
        cheqPayPage.splashText = .cheqpay
        cheqPayPage.bgColor = AppConfig.shared.activeTheme.splashBgColor3
        let cheqPayPageViewController = AppNav.shared.initViewController(StoryboardName.onboarding.rawValue, storyboardId: OnboardingStoryboardId.cSplashPage.rawValue, embedInNav: false) as! CSplashPageViewController
        cheqPayPageViewController.viewModel = cheqPayPage
        
        let pagingViewController = FixedPagingViewController(viewControllers: [budgetPageViewController, spendingPageViewController, cheqPayPageViewController])
        if var navBar = pagingViewController.navigationController?.navigationBar {
            transparentStatusBar(&navBar)
        }
        addChild(pagingViewController)
        self.view.addSubview(pagingViewController.view)
        AutoLayoutUtil.pinToSuperview(pagingViewController.view, padding: 0.0)
        pagingViewController.didMove(toParent: self)
        pagingViewController.delegate = self
    }
}
