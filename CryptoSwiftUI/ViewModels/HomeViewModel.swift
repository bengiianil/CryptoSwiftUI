//
//  HomeViewModel.swift
//  CryptoSwiftUI
//
//  Created by Bengi Anıl on 26.03.2024.
//

import Combine
import Foundation

class HomeViewModel: ObservableObject {
    @Published var allCoins = [CoinModel]()
    @Published var potfolioCoins = [CoinModel]()
    private let coinDataService = CoinDataService()
    private var cancellable = Set<AnyCancellable>()

    init() {
        addSubscriber()
    }
    
    func addSubscriber() {
        coinDataService.$allCoins.sink { [weak self] coins in
            guard let strongSelf = self else { return }
            strongSelf.allCoins = coins
        }
        .store(in: &cancellable)
    }
}
