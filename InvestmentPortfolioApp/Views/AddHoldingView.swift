import SwiftUI
import SwiftData

struct AddHoldingView: View {

    @EnvironmentObject private var appState: AppState
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var type = "Stock"
    @State private var quantity = ""
    @State private var buyPrice = ""
    @State private var latestPrice = ""
    @State private var buyDate = Date()
    @State private var notes = ""

    @State private var errorMessage = ""

    private let investmentTypes = [
        "Stock",
        "Mutual Fund",
        "Gold",
        "Fixed Deposit"
    ]

    var body: some View {

        Form {

            Section("Investment Information") {

                TextField(
                    "Investment Name",
                    text: $name
                )

                Picker(
                    "Investment Type",
                    selection: $type
                ) {

                    ForEach(investmentTypes, id: \.self) { item in
                        Text(item).tag(item)
                    }
                }

                TextField("Quantity", text: $quantity)
                    .keyboardType(.decimalPad)

                TextField(
                    "Purchase Price (₹)",
                    text: $buyPrice
                )
                .keyboardType(.decimalPad)

                TextField(
                    "Current Price (₹)",
                    text: $latestPrice
                )
                .keyboardType(.decimalPad)

                DatePicker(
                    "Purchase Date",
                    selection: $buyDate,
                    displayedComponents: .date
                )

                TextField(
                    "Notes",
                    text: $notes,
                    axis: .vertical
                )
                .lineLimit(3...5)
            }

            if !errorMessage.isEmpty {

                Section {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
            }

            Section {

                Button("Save Investment") {
                    saveInvestment()
                }
                .frame(maxWidth: .infinity)
                .fontWeight(.semibold)
            }
        }
        .navigationTitle("Add Investment")
    }

    private func saveInvestment() {

        let cleanName = name.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !appState.currentUserEmail.isEmpty else {
            errorMessage = "Please log in again before adding an investment."
            return
        }

        guard !cleanName.isEmpty else {
            errorMessage = "Enter an investment name."
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
            errorMessage = "Enter valid quantity and prices."
            return
        }

        let newHolding = Holding(
            name: cleanName,
            type: type,
            quantity: qty,
            buyPrice: buy,
            latestPrice: latest,
            buyDate: buyDate,
            notes: notes,
            ownerEmail: appState.currentUserEmail
        )

        context.insert(newHolding)

        do {

            try context.save()
            dismiss()

        } catch {

            errorMessage = error.localizedDescription
        }
    }
}
