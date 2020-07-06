//
//  SplashVC.swift
//  Cheq
//
//  Created by Amit.Rawal on 06/07/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {
    
    @IBOutlet weak var loaderImageVw: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.startSpinning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopSpinning()
    }
}

extension SplashVC {
    
    func startSpinning() {
        //loaderImageVw.image = UIImage(named:"sync-spinning")
        loaderImageVw.startRotating()
    }

    func stopSpinning() {
        loaderImageVw.stopRotating()
        //loaderImageVw.image = UIImage(named:"sync-not-spinning")
    }
}



