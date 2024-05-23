//
//  Date+.swift
//  CryptoSwiftUI
//
//  Created by Bengi Anıl on 23.05.2024.
//

import Foundation

extension Date {
    
    // "2021-03-13T20:49:26.606Z"
    init(dateString: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = formatter.date(from: dateString) ?? Date()
        self.init(timeInterval: 0, since: date)
    }
    
    private var shortFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    func shortDateString() -> String {
        return shortFormatter.string(from: self)
    }
}
