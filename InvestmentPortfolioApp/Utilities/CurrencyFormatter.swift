
import Foundation

enum CurrencyFormatter {

    static func format(_ amount: Double) -> String {

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "INR"
        formatter.locale = Locale(identifier: "en_IN")
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2

        return formatter.string(from: NSNumber(value: amount))
            ?? "₹0.00"
    }

    static func percentage(_ value: Double) -> String {

        return String(format: "%.2f%%", value)
    }
}
