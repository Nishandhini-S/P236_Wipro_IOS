

import Foundation

enum HoldingType: String, CaseIterable, Identifiable {

    case stock = "Stock"
    case mutualFund = "Mutual Fund"
    case gold = "Gold"
    case fixedDeposit = "Fixed Deposit"

    var id: String {
        rawValue
    }
}
