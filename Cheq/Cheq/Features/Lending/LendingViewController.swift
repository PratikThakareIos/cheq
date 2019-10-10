//
//  LendingViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 4/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class LendingViewController: UIViewController {

    var viewModel = LendingViewModel()
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var controlViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardHandling()
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ViewUtil.shared.circularMask(&self.controlView)
        ViewUtil.shared.circularMask(&self.infoView)
    }

    func setupUI() {
    }
}

extension LendingViewController {
    @objc override func baseScrollView() -> UIScrollView? {
        return self.scrollView
    }
}
