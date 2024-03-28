//
//  UIApplication+.swift
//  CryptoSwiftUI
//
//  Created by Bengi Anıl on 28.03.2024.
//

import Foundation
import SwiftUI

extension UIApplication {
    func hideKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

