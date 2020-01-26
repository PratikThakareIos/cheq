//
//  ImageView_Extension.swift
//  Cheq
//
//  Created by Xuwei Liang on 25/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

extension UIImageView {
    
    /// loads image by url to current UIImageView 
    func setImageForURL(_ url:String) {
        if let url = URL(string: url) {
            if let data = NSData(contentsOf: url) {
                self.image = UIImage(data: data as Data)
            }
        }
    }
}
