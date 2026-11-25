
import SwiftUI
import SwiftData

struct EditHoldingView: View {

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @Bindable var holding: Holding

    @State private var name = ""
    @State private var quantity = ""
    @State private var buyPrice = ""
    @State private var latestPrice = ""
    @State private var buyDate = Date()
    @State private var notes = ""

    @State private var errorMessage = ""

    var body: some View {

        Form {

            Section("Investment Information") {

                TextField("Investment Name", text: $name)

                LabeledContent("Type", value: holding.type)

                TextField("Quantity", text: $quantity)
                    .keyboardType(.decimalPad)

                TextField("Purchase Price (₹)", text: $buyPrice)
                    .keyboardType(.decimalPad)

                TextField("Latest Price (₹)", text: $latestPrice)
                    .keyboardType(.decimalPad)

                DatePicker(
                    "Purchase Date",
                    selection: $buyDate,
                    displayedComponents: .date
                )

                TextField("Notes", text: $notes, axis: .vertical)
                    .lineLimit(3...5)
            }

            Section("Updated Performance") {

                LabeledContent(
                    "Invested Amount",
                    value: CurrencyFormatter.format(
                        calculatedValue(quantity, buyPrice)
                    )
                )

                LabeledContent(
                    "Current Value",
                    value: CurrencyFormatter.format(
                        calculatedValue(quantity, latestPrice)
                    )
                )
            }

            if !errorMessage.isEmpty {

                Section {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
            }

            Section {

                Button("Save Changes") {
                    saveChanges()
                }
                .frame(maxWidth: .infinity)
                .fontWeight(.semibold)
            }
        }
        .navigationTitle("Edit Investment")
        .onAppear {

            name = holding.name
            quantity = String(holding.quantity)
            buyPrice = String(holding.buyPrice)
            latestPrice = String(holding.latestPrice)
            buyDate = holding.buyDate
            notes = holding.notes
        }
    }

    private func calculatedValue(
        _ quantityText: String,
        _ priceText: String
    ) -> Double {

        guard
            let qty = Double(quantityText),
            let price = Double(priceText),
            qty.isFinite,
            price.isFinite
        else {
            return 0
        }

        return qty * price
    }

    private func saveChanges() {

        let cleanName = name.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !cleanName.isEmpty else {
            errorMessage = "Investment name cannot be empty."
            return
        }

        guard
            let qty = Double(quantity),
            let buy = Double(buyPrice),
            let latest = Double(latestPrice),
            qty.isFinite,
            buy.isFinite,
            latest.isFinite,
            qty > 0,
            buy > 0,
            latest >= 0
        else {
            errorMessage = "Enter valid investment values."
            return
        }

        holding.name = cleanName
        holding.quantity = qty
        holding.buyPrice = buy
        holding.latestPrice = latest
        holding.buyDate = buyDate
        holding.notes = notes

        do {

            try context.save()
            dismiss()

        } catch {

            errorMessage = error.localizedDescription
        }
    }
}
