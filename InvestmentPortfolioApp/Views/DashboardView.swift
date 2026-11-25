import SwiftUI
import SwiftData

struct DashboardView: View {

    @EnvironmentObject var appState: AppState

    @Query(sort: \Holding.buyDate, order: .reverse)
    private var allHoldings: [Holding]

    private var holdings: [Holding] {

        allHoldings.filter { holding in
            holding.ownerEmail == appState.currentUserEmail.lowercased()
        }
    }

    private var totalInvested: Double {
        holdings.reduce(0) { $0 + $1.investedAmount }
    }

    private var currentValue: Double {
        holdings.reduce(0) { $0 + $1.currentValue }
    }

    private var totalProfitLoss: Double {
        currentValue - totalInvested
    }

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(alignment: .leading, spacing: 22) {

                    VStack(alignment: .leading, spacing: 5) {

                        Text("Welcome, \(appState.currentUserName)!")
                            .font(.title2.bold())

                        Text(appState.currentUserEmail)
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Text("Your Investment Overview")
                            .foregroundStyle(.secondary)
                    }

                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ],
                        spacing: 15
                    ) {

                        SummaryCard(
                            title: "Total Holdings",
                            value: "\(holdings.count)",
                            symbol: "briefcase.fill"
                        )

                        SummaryCard(
                            title: "Total Invested",
                            value: CurrencyFormatter.format(totalInvested),
                            symbol: "indianrupeesign.circle"
                        )

                        SummaryCard(
                            title: "Current Value",
                            value: CurrencyFormatter.format(currentValue),
                            symbol: "chart.line.uptrend.xyaxis"
                        )

                        SummaryCard(
                            title: "Overall Gain / Loss",
                            value: CurrencyFormatter.format(totalProfitLoss),
                            symbol: "chart.bar.fill",
                            color: totalProfitLoss > 0 ? .green :
                                totalProfitLoss < 0 ? .red : .secondary
                        )
                    }

                    VStack(alignment: .leading, spacing: 12) {

                        Text("Quick Actions")
                            .font(.title3.bold())

                        NavigationLink {
                            HoldingListView()
                        } label: {

                            Label(
                                "View All Holdings",
                                systemImage: "list.bullet"
                            )
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.blue)
                            .foregroundStyle(.white)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 12)
                            )
                        }

                        NavigationLink {
                            AddHoldingView()
                        } label: {

                            Label(
                                "Add New Investment",
                                systemImage: "plus.circle.fill"
                            )
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                Color(.secondarySystemBackground)
                            )
                            .foregroundStyle(.primary)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 12)
                            )
                        }
                    }

                    VStack(alignment: .leading, spacing: 12) {

                        Text("Recent Investments")
                            .font(.title3.bold())

                        if holdings.isEmpty {

                            ContentUnavailableView(
                                "No Investments Yet",
                                systemImage: "chart.pie",
                                description: Text(
                                    "Add your first investment."
                                )
                            )

                        } else {

                            ForEach(holdings.prefix(3)) { holding in

                                NavigationLink {
                                    HoldingDetailView(holding: holding)
                                } label: {
                                    HoldingRow(holding: holding)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

                    Button(role: .destructive) {

                        appState.logout()

                    } label: {

                        Label(
                            "Logout",
                            systemImage: "rectangle.portrait.and.arrow.right"
                        )
                        .frame(maxWidth: .infinity)
                        .padding()
                    }
                }
                .padding()
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
