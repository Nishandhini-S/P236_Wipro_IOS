
import SwiftUI

struct SummaryCard: View {

    let title: String
    let value: String
    let symbol: String

    var color: Color = .blue

    var body: some View {

        VStack(alignment: .leading, spacing: 12) {

            Image(systemName: symbol)
                .font(.title2)
                .foregroundStyle(color)

            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.title3.bold())
                .lineLimit(1)
                .minimumScaleFactor(0.65)
        }
        .padding()
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .background(
            Color(.secondarySystemBackground)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 15)
        )
    }
}

