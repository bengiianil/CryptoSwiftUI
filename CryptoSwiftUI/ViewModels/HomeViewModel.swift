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
    @Published var statistics: [StatisticModel] = []
    @Published var allCoins = [CoinModel]()
    @Published var coins = [CoinModel]()
    @Published var potfolioCoins = [CoinModel]()

    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
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
        
        marketDataService.$marketData
            .map(mapMarketData)
            .sink { [weak self] data in
            guard let strongSelf = self else { return }
            strongSelf.statistics = data
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
    
    private func mapMarketData(marketDataModel: MarketDataModel?) -> [StatisticModel] {
        var statistics: [StatisticModel] = []
        guard let data = marketDataModel else { return statistics }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let dominance = StatisticModel(title: "BTC Dominance", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let portfolio = StatisticModel(title: "Portfolio Volume", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        
        statistics.append(contentsOf: [marketCap, volume, dominance, portfolio])
        return statistics
    }
}
