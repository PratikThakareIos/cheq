//
//  LendingViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 4/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

enum WithdrawalAmount: String {
    case oneHundred = "100"
    case twoHundred = "200"
    case threeHundred = "300"
}

class LendingViewModel: BaseViewModel {
    var minusEnabled = true
    var plusEnabled = true
    // index at 1 is in the middle
    var selectedAmountIndex = 1
    var availableToWithdraw: [WithdrawalAmount] = [.oneHundred, .twoHundred, .threeHundred]
    
    
    func currentSelectedAmount()-> WithdrawalAmount {
        return availableToWithdraw[selectedAmountIndex]
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
