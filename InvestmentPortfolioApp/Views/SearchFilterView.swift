
import SwiftUI

struct SearchFilterView: View {

    @Binding var searchText: String
    @Binding var selectedType: String

    private let types = [
        "All",
        "Stock",
        "Mutual Fund",
        "Gold",
        "Fixed Deposit"
    ]

    var body: some View {

        VStack(
            alignment: .leading,
            spacing: 12
        ) {

            TextField(
                "Search investments...",
                text: $searchText
            )
            .textFieldStyle(.roundedBorder)

            HStack {

                Text("Filter by type")
                    .font(.subheadline)

                Spacer()

                Picker(
                    "Investment Type",
                    selection: $selectedType
                ) {

                    ForEach(types, id: \.self) { type in

                        Text(type)
                            .tag(type)
                    }
                }
                .pickerStyle(.menu)
            }
        }
    }
}

