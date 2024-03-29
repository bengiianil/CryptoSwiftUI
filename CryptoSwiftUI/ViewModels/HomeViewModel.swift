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
    @Published var isLoading = false

    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()

    init() {
        addSubscriber()
    }
    
    private func addSubscriber() {
        coinDataService.$allCoins.sink { [weak self] coins in
            guard let strongSelf = self else { return }
            strongSelf.allCoins = coins
            strongSelf.coins = coins
        }
        .store(in: &cancellables)
        
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities) // the entity binding wait until we receive allCoins
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] coins in
                guard let strongSelf = self else { return }
                strongSelf.potfolioCoins = coins
            }
            .store(in: &cancellables)
        
        marketDataService.$marketData
            .combineLatest($potfolioCoins)
            .map(mapMarketData)
            .sink { [weak self] data in
                guard let strongSelf = self else { return }
                strongSelf.statistics = data
                strongSelf.isLoading = false
            }
            .store(in: &cancellables)
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
    
    func reloadData() {
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getMarketData()
    }
    
    private func mapAllCoinsToPortfolioCoins(allCoins: [CoinModel], portfolioEntities: [PortfolioEntity]) -> [CoinModel] {
         allCoins.compactMap { (coin) -> CoinModel? in
             guard let entity = portfolioEntities.first(where: { $0.coinId == coin.id }) else {
                 return nil
             }
             return coin .updateHoldings(amount: entity.amount)
         }
     }
     
    private func mapMarketData(marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
        var statistics: [StatisticModel] = []
        guard let data = marketDataModel else { return statistics }
        
        let portfolioValue = portfolioCoins.map { $0.currentHoldingsValue }
                                           .reduce(0, +)
        
        let previousValue = portfolioCoins.map { (coin) -> Double in
            let currentValue = coin.currentHoldingsValue
            let percentChange = coin.priceChangePercentage24H ?? 0 / 100
            let previousValue = currentValue / (1 + percentChange)
            return previousValue
        }
        .reduce(0, +)
        
        let percentValue = ((portfolioValue - previousValue) / previousValue)

        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let dominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        let portfolio = StatisticModel(title: "Portfolio Volume", value: portfolioValue.percentString(), percentageChange: percentValue)
        
        statistics.append(contentsOf: [marketCap, volume, dominance, portfolio])
        return statistics
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
}
