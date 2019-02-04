//
//  CurrencyField.swift
//  
//
//  Created by Thiago Lima on 20/05/2018.
//  Copyright © 2018. All rights reserved.
//

import Foundation

class CurrencyField: UITextField {
    var string: String { return text ?? "" }
    
    var decimal: Decimal {
        return string.digits.decimal /
            Decimal(pow(10, Double(Formatter.currency.maximumFractionDigits)))
    }
    
    var decimalNumber: NSDecimalNumber { return decimal.number }
    var doubleValue: Double { return decimalNumber.doubleValue }
    var integerValue: Int { return decimalNumber.intValue   }
    let maximum: Decimal = 999_999_999.99
    private var lastValue: String = ""
    
    override func willMove(toSuperview newSuperview: UIView?) {
        Formatter.currency.locale = Locale(identifier: "pt_BR")
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        keyboardType = .numberPad
        textAlignment = .right
        editingChanged()
    }
    
    override func deleteBackward() {
        text = string.digits.dropLast().string
        editingChanged()
    }
    
    @objc func editingChanged() {
        guard decimal <= maximum else {
            text = lastValue
            return
        }
        lastValue = Formatter.currency.string(for: decimal) ?? ""
        text = lastValue
    }
    
}

extension Decimal {
    var number: NSDecimalNumber { return NSDecimalNumber(decimal: self) }
}

extension NumberFormatter {
    convenience init(numberStyle: Style) {
        self.init()
        self.numberStyle = numberStyle
    }
}

extension Formatter {
    static let currency = NumberFormatter(numberStyle: .currency)
}
