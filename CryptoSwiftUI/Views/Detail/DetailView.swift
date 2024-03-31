//
//  DetailView.swift
//  CryptoSwiftUI
//
//  Created by Bengi Anıl on 31.03.2024.
//

import SwiftUI

struct DetailLoadingView: View {
    @Binding var coin: CoinModel?
    
    init(coin: Binding<CoinModel?>) {
        self._coin = coin
    }
    
    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {
    let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
    }
    
    var body: some View {
        Text(coin.name)
    }
}

#Preview {
    DetailView(coin: Preview.instance.coin)
}
