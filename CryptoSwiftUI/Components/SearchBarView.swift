//
//  SearchBarView.swift
//  CryptoSwiftUI
//
//  Created by Bengi Anıl on 31.03.2024.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchedText: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            
            TextField("Search by name or symbol...", text: $searchedText)
                .autocorrectionDisabled()
                .overlay(alignment: .trailing) {
                    Image(systemName: "xmark.circle.fill")
                        .opacity(searchedText.isEmpty ? 0 : 1)
                        .onTapGesture {
                            UIApplication.shared.hideKeyboard()
                            searchedText = ""
                        }
                }
        }
        .foregroundStyle(Color.theme.accent)
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.background)
                .shadow(color: Color.theme.accent.opacity(0.25), radius: 10)
        )
        .padding()

    }
}

#Preview {
    SearchBarView(searchedText: .constant(""))
}
