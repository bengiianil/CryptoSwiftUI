//
//  CoinImageView.swift
//  CryptoSwiftUI
//
//  Created by Bengi Anıl on 27.03.2024.
//

import SwiftUI

struct CoinImageView: View {
    @StateObject var imageViewModel: ImageViewModel

    init(coin: CoinModel) {
        _imageViewModel = StateObject(wrappedValue: ImageViewModel(coin: coin))
    }
    
    var body: some View {
        if let image = imageViewModel.image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
        } else if imageViewModel.isLoading {
            ProgressView()
        } else {
            Image(systemName: "questionmark")
                .foregroundStyle(Color.theme.secondaryText)
        }
    }
}

#Preview {
    CoinImageView(coin: DeveloperPreview.instance.coin)
}
