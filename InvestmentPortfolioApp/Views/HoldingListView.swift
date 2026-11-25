import SwiftUI
import SwiftData

struct HoldingListView: View {

    @EnvironmentObject private var appState: AppState
    @Environment(\.modelContext) private var context

    @Query(sort: \Holding.buyDate, order: .reverse)
    private var allHoldings: [Holding]

    @State private var searchText = ""
    @State private var selectedType = "All"

    @State private var holdingToDelete: Holding?
    @State private var showDeleteAlert = false

    private let types = [
        "All",
        "Stock",
        "Mutual Fund",
        "Gold",
        "Fixed Deposit"
    ]

    private var myHoldings: [Holding] {

        allHoldings.filter { holding in
            holding.ownerEmail == appState.currentUserEmail.lowercased()
        }
    }

    private var filteredHoldings: [Holding] {

        myHoldings.filter { holding in

            let matchesSearch =
                searchText.isEmpty ||
                holding.name.localizedCaseInsensitiveContains(searchText)

            let matchesType =
                selectedType == "All" ||
                holding.type == selectedType

            return matchesSearch && matchesType
        }
    }

    var body: some View {

        VStack(spacing: 12) {

            HStack {

                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)

                TextField(
                    "Search investments...",
                    text: $searchText
                )

                if !searchText.isEmpty {

                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(12)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)

            HStack {

                Text("Filter")
                    .foregroundStyle(.secondary)

                Picker(
                    "Investment Type",
                    selection: $selectedType
                ) {

                    ForEach(types, id: \.self) { item in
                        Text(item).tag(item)
                    }
                }
                .pickerStyle(.menu)

                Spacer()

                Text("\(filteredHoldings.count) investments")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)

            if filteredHoldings.isEmpty {

                Spacer()

                ContentUnavailableView(
                    searchText.isEmpty && selectedType == "All"
                    ? "No Investments Yet"
                    : "No Matching Investments",
                    systemImage: "briefcase",
                    description: Text(
                        searchText.isEmpty && selectedType == "All"
                        ? "Add your first investment."
                        : "Try another search or filter."
                    )
                )

                Spacer()

            } else {

                List {

                    ForEach(filteredHoldings) { holding in

                        HStack(spacing: 8) {

                            NavigationLink {

                                HoldingDetailView(holding: holding)

                            } label: {

                                HoldingRow(holding: holding)
                            }
                            .buttonStyle(.plain)

                            Button {

                                holdingToDelete = holding
                                showDeleteAlert = true

                            } label: {

                                Image(systemName: "trash")
                                    .font(.title3)
                                    .foregroundStyle(.red)
                                    .padding(10)
                            }
                            .buttonStyle(.borderless)
                            .accessibilityLabel(
                                "Delete \(holding.name)"
                            )
                        }
                        .padding(.vertical, 5)
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("My Holdings")
        .toolbar {

            ToolbarItem(placement: .topBarTrailing) {

                NavigationLink {

                    AddHoldingView()

                } label: {

                    Image(systemName: "plus")
                }
            }
        }
        .alert(
            "Delete Investment?",
            isPresented: $showDeleteAlert
        ) {

            Button("Cancel", role: .cancel) {
                holdingToDelete = nil
            }

            Button("Delete", role: .destructive) {
                deleteHolding()
            }

        } message: {

            Text("Are you sure you want to delete this investment?")
        }
    }

    private func deleteHolding() {

        guard let holding = holdingToDelete,
              holding.ownerEmail == appState.currentUserEmail.lowercased()
        else {
            holdingToDelete = nil
            return
        }

        context.delete(holding)

        do {

            try context.save()
            holdingToDelete = nil

        } catch {

            print("Delete failed: \(error.localizedDescription)")
        }
    }
}
