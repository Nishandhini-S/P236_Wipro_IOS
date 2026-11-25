
import SwiftUI
import SwiftData

struct HoldingDetailView: View {

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    let holding: Holding

    @State private var showDeleteConfirmation = false

    var body: some View {

        List {

            Section("Investment Information") {

                detail("Investment Name", holding.name)
                detail("Investment Type", holding.type)
                detail("Quantity", holding.quantity.formatted())

                detail(
                    "Purchase Price",
                    CurrencyFormatter.format(holding.buyPrice)
                )

                detail(
                    "Latest Price",
                    CurrencyFormatter.format(holding.latestPrice)
                )

                detail(
                    "Purchase Date",
                    holding.buyDate.formatted(date: .long, time: .omitted)
                )

                detail(
                    "Notes",
                    holding.notes.isEmpty ? "No notes" : holding.notes
                )
            }

            Section("Investment Performance") {

                detail(
                    "Invested Amount",
                    CurrencyFormatter.format(holding.investedAmount)
                )

                detail(
                    "Current Value",
                    CurrencyFormatter.format(holding.currentValue)
                )

                detail(
                    "Profit / Loss",
                    CurrencyFormatter.format(holding.profitLoss)
                )

                detail(
                    "Profit / Loss Percentage",
                    CurrencyFormatter.percentage(
                        holding.profitLossPercentage
                    )
                )

                detail("Performance Status", holding.status)
            }

            Section("Manage Investment") {

                NavigationLink {

                    EditHoldingView(holding: holding)

                } label: {

                    Label("Edit Investment", systemImage: "pencil")
                }

                Button(role: .destructive) {

                    showDeleteConfirmation = true

                } label: {

                    Label("Delete Investment", systemImage: "trash")
                }
            }
        }
        .navigationTitle("Investment Details")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog(
            "Delete this investment?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {

            Button("Delete", role: .destructive) {

                context.delete(holding)

                do {
                    try context.save()
                    dismiss()
                } catch {
                    print("Delete error: \(error.localizedDescription)")
                }
            }

            Button("Cancel", role: .cancel) {}
        }
    }

    private func detail(
        _ title: String,
        _ value: String
    ) -> some View {

        HStack(alignment: .top) {

            Text(title)

            Spacer()

            Text(value)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.trailing)
        }
    }
}
