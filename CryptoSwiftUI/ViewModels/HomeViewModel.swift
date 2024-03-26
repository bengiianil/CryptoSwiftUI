//
//  HomeViewModel.swift
//  CryptoSwiftUI
//
//  Created by Bengi Anıl on 26.03.2024.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var allCoins = [CoinModel]()
    @Published var potfolioCoins = [CoinModel]()
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.allCoins.append(DeveloperPreview.instance.coin)
            self.potfolioCoins.append(DeveloperPreview.instance.coin)
        }
    }
}
