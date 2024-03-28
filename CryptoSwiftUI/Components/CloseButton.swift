//
//  CloseButton.swift
//  CryptoSwiftUI
//
//  Created by Bengi Anıl on 28.03.2024.
//

import SwiftUI

struct CloseButton: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
        }
    }
}

#Preview {
    CloseButton()
}
