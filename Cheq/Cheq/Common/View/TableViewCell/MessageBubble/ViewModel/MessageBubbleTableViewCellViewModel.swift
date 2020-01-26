//
//  MessageBubbleTableViewCellViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 15/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 ViewModel for **MessageBubbleTableViewCell**. **MessageBubbleTableViewCell** is a notice message on Lending screen UI design.
 */
class MessageBubbleTableViewCellViewModel: TableViewCellViewModelProtocol {
    
    /// reuse identifier
    var identifier = "MessageBubbleTableViewCell"
    
    /// Default message text, update this message accordingly. Message should be fetched from backend API.
    var messageText = "You have used up your maximum cash out amount. Come back again later after you check-in for work."
    
    
    /// Method to retrieve image icon for message bubble 
    func imageIcon()-> String {
        return "notificationIcon"
    }
}
