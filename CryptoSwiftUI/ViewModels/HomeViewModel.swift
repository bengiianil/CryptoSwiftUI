//
//  HomeViewModel.swift
//  CryptoSwiftUI
//
//  Created by Bengi Anıl on 26.03.2024.
//

import Combine
import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var allCoins = [CoinModel]()
    @Published var coins = [CoinModel]()
    @Published var potfolioCoins = [CoinModel]()
    private let coinDataService = CoinDataService()
    private var cancellable = Set<AnyCancellable>()

    init() {
        addSubscriber()
    }
    
    private func addSubscriber() {
        coinDataService.$allCoins.sink { [weak self] coins in
            guard let strongSelf = self else { return }
            strongSelf.allCoins = coins
            strongSelf.coins = coins
        }
        .store(in: &cancellable)
    }
    
    func applyFilter(text: String) {
        var searchedCoins: [CoinModel] {
            text.isEmpty ? allCoins : allCoins.filter {
                $0.name.range(of: text, options: .caseInsensitive) != nil ||
                $0.symbol.range(of: text, options: .caseInsensitive) != nil ||
                $0.id.range(of: text, options: .caseInsensitive) != nil
            }
        }
        coins = searchedCoins
    }
}
