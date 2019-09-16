//
//  OnfidoKYCViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 12/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import Onfido

class KYCViewController: UIViewController {

    @IBOutlet weak var verifyButton: CButton!
    private let token = "eyJhbGciOiJIUzI1NiJ9.eyJwYXlsb2FkIjoidWNSRXlHQTV2anptRFBXZjRZRFFqN3ZWazg2MHpPd1RTMVZ5ZnFlUkRuT2YwbHp0U0x6c2JQNkxhVXpzXG5scEZNU2RjMmJZVk1nWFI1Vys4K3NnMGNRSEpweVJwM0E4UVdKV0RobVY1ZDZRTT1cbiIsInV1aWQiOiJIbVFxNVpvWG1XRiIsImV4cCI6MTU2ODM2MzExNywidXJscyI6eyJvbmZpZG9fYXBpX3VybCI6Imh0dHBzOi8vYXBpLm9uZmlkby5jb20iLCJ0ZWxlcGhvbnlfdXJsIjoiaHR0cHM6Ly90ZWxlcGhvbnkub25maWRvLmNvbSIsImRldGVjdF9kb2N1bWVudF91cmwiOiJodHRwczovL3Nkay5vbmZpZG8uY29tIiwic3luY191cmwiOiJodHRwczovL3N5bmMub25maWRvLmNvbSIsImhvc3RlZF9zZGtfdXJsIjoiaHR0cHM6Ly9pZC5vbmZpZG8uY29tIn19.edhjNYgbdl9W_YqikPlPhdoIiMVI92ZYoJD3S7_ybAc"

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension KYCViewController {
    @IBAction func createApplication(_ sender: Any) {
        let config = try! OnfidoConfig.builder()
            .withSDKToken(token)
            .withWelcomeStep()
            .withDocumentStep()
            .withFaceStep(ofVariant: .photo(withConfiguration: nil))
            .build()
        let onfidoFlow = OnfidoFlow(withConfiguration: config)
                .with(responseHandler: { results in
                    // Callback when flow ends
                })
        let onfidoRun = try! onfidoFlow.run()
        
        self.present(onfidoRun, animated: true, completion: nil) //`self` should be your view controller
    }
}
