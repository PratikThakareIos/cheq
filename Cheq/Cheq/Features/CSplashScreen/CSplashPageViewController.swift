//
//  CSplashPageViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 20/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class CSplashPageViewController: UIViewController {
    
    @IBOutlet weak var splashImage: UIImageView!
    @IBOutlet weak var splashText: UIImageView!
    
    var viewModel: CSplashPageViewModel = CSplashPageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        splashImage.image = UIImage.init(named: self.viewModel.splashImage.rawValue)
        splashText.image = UIImage.init(named: self.viewModel.splashText.rawValue)
        self.view.backgroundColor = viewModel.bgColor
    }
}
