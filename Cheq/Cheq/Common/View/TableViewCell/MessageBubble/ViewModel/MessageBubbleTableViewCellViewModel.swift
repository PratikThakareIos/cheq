//
//  MessageBubbleTableViewCellViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 15/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class MessageBubbleTableViewCellViewModel: TableViewCellViewModelProtocol {
    
    var identifier = "MessageBubbleTableViewCell"
    var messageText = "You have used up your maximum cash out amount. Come back again later after you check-in for work."
    
    func imageIcon()-> String {
        return "notificationIcon"
    }
}
