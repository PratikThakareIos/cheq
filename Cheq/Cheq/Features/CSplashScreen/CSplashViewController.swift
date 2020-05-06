//
//  CSplashViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 20/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class CSplashViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var startButton: CNButton!

    var viewControllers: [CSplashPageViewController] = []
    var currentViewControllerIndex = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.pageControl.pageIndicatorTintColor = AppConfig.shared.activeTheme.lightGrayColor.withAlphaComponent(AppConfig.shared.activeTheme.nonActiveAlpha)
        self.pageControl.currentPageIndicatorTintColor = AppConfig.shared.activeTheme.primaryColor
        let budgetPage = CSplashPageViewModel()
        budgetPage.splashImage = .budget
        budgetPage.splashText = .budget
        budgetPage.bgColor = AppConfig.shared.activeTheme.splashBgColor1
        let budgetPageViewController = AppNav.shared.initViewController(StoryboardName.onboarding.rawValue, storyboardId: OnboardingStoryboardId.cSplashPage.rawValue, embedInNav: false) as! CSplashPageViewController
        budgetPageViewController.viewModel = budgetPage
        budgetPageViewController.view.tag = 0
        
        let spendingPage = CSplashPageViewModel()
        spendingPage.splashImage = .spending
        spendingPage.splashText = .spending
        spendingPage.bgColor = AppConfig.shared.activeTheme.splashBgColor2
        let spendingPageViewController = AppNav.shared.initViewController(StoryboardName.onboarding.rawValue, storyboardId: OnboardingStoryboardId.cSplashPage.rawValue, embedInNav: false) as! CSplashPageViewController
        spendingPageViewController.viewModel = spendingPage
        spendingPageViewController.view.tag = 1
        
        let cheqPayPage = CSplashPageViewModel()
        cheqPayPage.splashImage = .cheqpay
        cheqPayPage.splashText = .cheqpay
        cheqPayPage.bgColor = AppConfig.shared.activeTheme.splashBgColor3
        let cheqPayPageViewController = AppNav.shared.initViewController(StoryboardName.onboarding.rawValue, storyboardId: OnboardingStoryboardId.cSplashPage.rawValue, embedInNav: false) as! CSplashPageViewController
        cheqPayPageViewController.viewModel = cheqPayPage
        cheqPayPageViewController.view.tag = 2
        
        viewControllers = [budgetPageViewController, spendingPageViewController, cheqPayPageViewController]
        
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options:
            [:])
        pageViewController.setViewControllers([budgetPageViewController], direction: .forward, animated: false, completion: nil)
        self.pageControl.currentPage = 0
        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        addChild(pageViewController)
        self.view.addSubview(pageViewController.view)
        AutoLayoutUtil.pinToSuperview(pageViewController.view, padding: 0.0)
        pageViewController.didMove(toParent: self)
        self.startButton.createShadowLayer()
        self.startButton.setType(.normal)
        self.view.bringSubviewToFront(pageControl)
        self.view.bringSubviewToFront(startButton)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let viewControllerIndex = self.viewControllers.index(of: viewController as! CSplashPageViewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return nil }
        
        guard self.viewControllers.count > previousIndex else { return nil }
        return self.viewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = self.viewControllers.index(of: viewController as! CSplashPageViewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        guard nextIndex <= self.viewControllers.count - 1  else { return nil }
        return self.viewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed { return }
        let currentPageVc = pageViewController.viewControllers?.first as! CSplashPageViewController
        let tag = currentPageVc.view.tag
        if tag == 2 {
            UIView.animate(withDuration: AppConfig.shared.activeTheme.quickAnimationDuration, animations: {
                self.pageControl.alpha = 0.0
            }, completion: { _ in
                self.showStartButton()
            })
        } else {
            if self.pageControl.alpha == 0.0 {
                self.pageControl.currentPage = tag
                UIView.animate(withDuration: AppConfig.shared.activeTheme.quickAnimationDuration, animations: {
                    self.pageControl.alpha = 1.0
                }, completion: { _ in
                    self.hideStartButton()
                })
            } else {
                self.pageControl.currentPage = tag
            }
        }
    }
    
    func showStartButton() {
        UIView.animate(withDuration: AppConfig.shared.activeTheme.quickAnimationDuration) {
            self.startButton.alpha = 1.0
        }
    }
    
    func hideStartButton() {
        UIView.animate(withDuration: AppConfig.shared.activeTheme.quickAnimationDuration) {
            self.startButton.alpha = 0.0
        }
    }
    
    @IBAction func getStarted(_ sender: Any) {
        AppConfig.shared.markFirstInstall()
        let storyboard = UIStoryboard(name: StoryboardName.onboarding.rawValue, bundle: Bundle.main)
        let regViewController = storyboard.instantiateViewController(withIdentifier: OnboardingStoryboardId.registration.rawValue) as! RegistrationVC
        let nav = UINavigationController(rootViewController: regViewController)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
}
