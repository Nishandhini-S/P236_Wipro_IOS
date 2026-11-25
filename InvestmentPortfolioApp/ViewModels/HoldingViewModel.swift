import Foundation
import SwiftData

@MainActor
final class HoldingViewModel {

    func addHolding(
        context: ModelContext,
        name: String,
        type: String,
        quantity: Double,
        buyPrice: Double,
        latestPrice: Double,
        buyDate: Date,
        notes: String,
        ownerEmail: String
    ) {

        let holding = Holding(
            name: name,
            type: type,
            quantity: quantity,
            buyPrice: buyPrice,
            latestPrice: latestPrice,
            buyDate: buyDate,
            notes: notes,
            ownerEmail: ownerEmail
        )

        context.insert(holding)
    }

    func deleteHolding(
        context: ModelContext,
        holding: Holding
    ) {

        context.delete(holding)
    }

    func saveChanges(
        context: ModelContext
    ) throws {

        try context.save()
    }
}
