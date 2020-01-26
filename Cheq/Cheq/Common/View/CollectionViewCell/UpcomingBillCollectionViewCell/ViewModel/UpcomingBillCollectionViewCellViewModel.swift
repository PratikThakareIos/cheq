//
//  UpcomingBillCollectionViewCellViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 8/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 UpcomingBillCollectionViewCellViewModel must follow **CollectionViewCellViewModelProtocol** with **identifier** variable. **data** holds the upcoming bill response model object which we use to drive the UI. 
 */
class UpcomingBillCollectionViewCellViewModel: CollectionViewCellViewModelProtocol {
    var identifier: String = "UpcomingBillCollectionViewCell"
    var data: GetUpcomingBillResponse = GetUpcomingBillResponse(_description: "", merchant: "", merchantLogoUrl: "", amount: 0.0, dueDate: "", daysToDueDate: 0, recurringFrequency: GetUpcomingBillResponse.RecurringFrequency.weekly, categoryCode: GetUpcomingBillResponse.CategoryCode.others, categoryTitle: "")
}
