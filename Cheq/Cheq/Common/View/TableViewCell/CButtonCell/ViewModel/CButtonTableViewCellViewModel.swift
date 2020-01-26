//
//  CButtonTableViewCellViewModel
//  Cheq
//
//  Created by XUWEI LIANG on 13/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/// title enums from Lending view controllers
enum keyButtonTitle: String {
    case Cashout = "Cash out now"
}

/// viewModel for **CButtonTableViewCell**
class CButtonTableViewCellViewModel: TableViewCellViewModelProtocol {
    
    /// reuse identifier
    var identifier: String = "CButtonTableViewCell"
    
    /// title button, we use **keyButtonTitle** enum to look up instead of hardcoding
    var title: String = keyButtonTitle.Cashout.rawValue
    
    /// icon next to the button title, we use enums from IntroEmoji to retrieve the image names, instead of hardcoding 
    var icon: String = IntroEmoji.speedy.rawValue
}
