//
//  CircleButton.swift
//  CryptoSwiftUI
//
//  Created by Bengi Anıl on 26.03.2024.
//

import SwiftUI

struct CircleButton: View {
    let imageName: String
    
    var body: some View {
        Image(systemName: imageName)
            .font(.headline)
            .foregroundStyle(Color.theme.accent)
            .frame(width: 50, height: 50)
            .background(Circle()
                          .foregroundStyle(Color.theme.background))
            .shadow(color: Color.theme.accent.opacity(0.25), radius: 12)
            .padding()
    }
}

#Preview(traits: .sizeThatFitsLayout) {
        CircleButton(imageName: "info")
//            .preferredColorScheme(.dark)
}
