
import Foundation

struct DashboardViewModel {

    func totalHoldings(_ holdings: [Holding]) -> Int {

        holdings.count
    }

    func totalInvested(_ holdings: [Holding]) -> Double {

        holdings.reduce(0) {
            $0 + $1.investedAmount
        }
    }

    func currentValue(_ holdings: [Holding]) -> Double {

        holdings.reduce(0) {
            $0 + $1.currentValue
        }
    }

    func totalProfitLoss(_ holdings: [Holding]) -> Double {

        holdings.reduce(0) {
            $0 + $1.profitLoss
        }
    }
}

