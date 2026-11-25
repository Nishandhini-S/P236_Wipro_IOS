
import SwiftUI

struct HoldingRow: View {

    let holding: Holding

    private var profitColor: Color {

        if holding.profitLoss > 0 {
            return .green
        } else if holding.profitLoss < 0 {
            return .red
        } else {
            return .secondary
        }
    }

    var body: some View {

        HStack {

            VStack(alignment: .leading, spacing: 7) {

                Text(holding.name)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(holding.type)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text("Quantity: \(holding.quantity.formatted())")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(
                    "Current Value: \(CurrencyFormatter.format(holding.currentValue))"
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 7) {

                Text(CurrencyFormatter.format(holding.profitLoss))
                    .font(.headline)
                    .foregroundStyle(profitColor)

                Text(holding.status)
                    .font(.caption.bold())
                    .foregroundStyle(profitColor)

                Text(
                    CurrencyFormatter.percentage(
                        holding.profitLossPercentage
                    )
                )
                .font(.caption)
                .foregroundStyle(profitColor)
            }
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .contentShape(Rectangle())
    }
}
