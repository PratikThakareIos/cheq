//
//  LendingViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 4/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 ViewModel for **AmountSelectTableViewCell**
 */
class AmountSelectTableViewCellViewModel: TableViewCellViewModelProtocol {
    
    /// reuse identifier
    var identifier: String = "AmountSelectTableViewCell"

    /// these variable controls the state of the minus button on the Amount Select widget
    var minusEnabled = true
    
    /// these variable controls the state of the plus button on the Amount Select widget
    var plusEnabled = true
    
    /// index starts on 0, this is updated as different amount is selected
    var selectedAmountIndex = 0
    
    /// availableToWithdraw is an Array of the possible amounts to borrow, this should be loaded from backend
    var availableToWithdraw: [String] = ["100", "200", "300"]
    
    /// **buildAvaialbleToWithDraw** is method to initialise the state of Amount Select widget.
    func buildAvaialbleToWithDraw(low: Int, limit: Int, increment: Int) {
        var range = [String]()
        for current in stride(from: low, through: limit, by: increment) {
            range.append(String(current))
        }
        availableToWithdraw = range
        selectedAmountIndex = availableToWithdraw.count - 1 //manish
    }
    
    
    /// this returns the current selected amount
    func currentSelectedAmount()-> String {
        if selectedAmountIndex >= 0, selectedAmountIndex < availableToWithdraw.count  {
            return availableToWithdraw[selectedAmountIndex]
        } else {
            if (availableToWithdraw.count > 0){
                return availableToWithdraw[0]
            }
            return "0"
        }
    }
    
    /// this method applies the logic when user clicks on plus 
    func plus() {
        guard availableToWithdraw.count > 0 else { return }
        if selectedAmountIndex < availableToWithdraw.count {
            selectedAmountIndex = selectedAmountIndex + 1
        }
        
        if shouldDisablePlus() { plusEnabled = false }
        minusEnabled = true
    }
    
    /// this method applies the logic when user clicks on minus
    func minus() {
        guard availableToWithdraw.count > 0 else { return }
        if selectedAmountIndex > 0 {
            selectedAmountIndex = selectedAmountIndex - 1
        }
        if shouldDisableMinus() { minusEnabled = false }
        plusEnabled = true
    }
    
    /// method to abstract the logic for checking whether the plus button should be disabled
    func shouldDisablePlus()->Bool {
        if (availableToWithdraw.count == 0){
            return true
        }
        return selectedAmountIndex == availableToWithdraw.count - 1
    }
    
    /// method to abstract the logic for checking whether the minus button should be disabled
    func shouldDisableMinus()->Bool {
        if (availableToWithdraw.count == 0){
             return true
        }
        return selectedAmountIndex == 0
    }
}
