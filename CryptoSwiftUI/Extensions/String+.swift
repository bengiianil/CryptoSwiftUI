//
//  String+.swift
//  CryptoSwiftUI
//
//  Created by Bengi Anıl on 23.05.2024.
//

import Foundation

extension String {
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
