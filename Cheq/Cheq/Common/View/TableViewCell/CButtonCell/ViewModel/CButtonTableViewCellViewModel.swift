//
//  CButtonTableViewCellViewModel
//  Cheq
//
//  Created by XUWEI LIANG on 13/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

enum keyButtonTitle: String {
    case Cashout = "Cash out now"
}

class CButtonTableViewCellViewModel: TableViewCellViewModelProtocol {
    var identifier: String = "CButtonTableViewCell"
    var title: String = keyButtonTitle.Cashout.rawValue
    var icon: String = IntroEmoji.speedy.rawValue
}
