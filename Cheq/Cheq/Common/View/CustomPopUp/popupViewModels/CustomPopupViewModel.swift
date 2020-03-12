//
//  CustomPopupViewModel.swift
//  Cheq
//
//  Created by iTelaSoft-PC on 2/5/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import Foundation
import UIKit

class CustomPopupViewModel {
    
    /// **CustomPopupViewModel** contains the data that drives the UI for CustomPopupModel
    var data: CustomPopupModel = CustomPopupModel(description: "", imageName: "", modalHeight: 0.0, headerTitle: "")
}

///Model clas for the CustomPopupViewModel
struct CustomPopupModel {
    public var description : String?
    public var imageName : String?
    public var modalheight : CGFloat?
    public var headerTitle : String?
    
    public init(description:String,imageName:String? = nil,modalHeight:CGFloat,headerTitle:String){
        self.description = description
        self.imageName = imageName
        self.modalheight = modalHeight
        self.headerTitle = headerTitle
    }
}
