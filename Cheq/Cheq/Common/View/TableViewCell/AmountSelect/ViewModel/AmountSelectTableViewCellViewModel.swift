//
//  LendingViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 4/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class AmountSelectTableViewCellViewModel: TableViewCellViewModelProtocol {
    
    var identifier: String = "AmountSelectTableViewCell"

    var minusEnabled = true
    var plusEnabled = true
    // index starts on 0
    var selectedAmountIndex = 0
    var availableToWithdraw: [String] = ["100", "200", "300"]
    
    
    func buildAvaialbleToWithDraw(low: Int, limit: Int, increment: Int) {
        var range = [String]()
        for current in stride(from: low, through: limit, by: increment) {
            range.append(String(current))
        }
        availableToWithdraw = range
    }
    
    func currentSelectedAmount()-> String {
        if selectedAmountIndex >= 0, selectedAmountIndex < availableToWithdraw.count  {
            return availableToWithdraw[selectedAmountIndex]
        } else {
            return availableToWithdraw[0]
        }
    }
    
    func plus() {
        
        guard availableToWithdraw.count > 0 else { return }
        if selectedAmountIndex < availableToWithdraw.count {
            selectedAmountIndex = selectedAmountIndex + 1
        }
        
        if shouldDisablePlus() { plusEnabled = false }
        minusEnabled = true
    }
    
    func minus() {
        
        guard availableToWithdraw.count > 0 else { return }
        if selectedAmountIndex > 0 {
            selectedAmountIndex = selectedAmountIndex - 1
        }
        
        // check if we
        if shouldDisableMinus() { minusEnabled = false }
        plusEnabled = true
    }
    
    func shouldDisablePlus()->Bool {
        return selectedAmountIndex == availableToWithdraw.count - 1
    }
    
    func shouldDisableMinus()->Bool {
        return selectedAmountIndex == 0
    }
}
