import Foundation
import SwiftData

@Model
final class Holding {

    var id: UUID
    var name: String
    var type: String
    var quantity: Double
    var buyPrice: Double
    var latestPrice: Double
    var buyDate: Date
    var notes: String
    var ownerEmail: String = ""

    init(
        name: String,
        type: String,
        quantity: Double,
        buyPrice: Double,
        latestPrice: Double,
        buyDate: Date,
        notes: String,
        ownerEmail: String
    ) {
        self.id = UUID()
        self.name = name
        self.type = type
        self.quantity = quantity
        self.buyPrice = buyPrice
        self.latestPrice = latestPrice
        self.buyDate = buyDate
        self.notes = notes
        self.ownerEmail = ownerEmail.lowercased()
    }

    var investedAmount: Double {
        quantity * buyPrice
    }

    var currentValue: Double {
        quantity * latestPrice
    }

    var profitLoss: Double {
        currentValue - investedAmount
    }

    var profitLossPercentage: Double {
        guard investedAmount > 0 else {
            return 0
        }

        return (profitLoss / investedAmount) * 100
    }

    var status: String {
        if profitLoss > 0 {
            return "Gain"
        } else if profitLoss < 0 {
            return "Loss"
        } else {
            return "Break-even"
        }
    }
}
