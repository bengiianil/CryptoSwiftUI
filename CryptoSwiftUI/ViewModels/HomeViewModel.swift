//
//  homeViewModel.swift
//  CryptoSwiftUI
//
//  Created by Bengi Anıl on 26.03.2024.
//

import Combine
import Foundation
import SwiftUI

enum SortOption {
    case rank
    case rankReversed
    case holdings
    case holdingsReversed
    case price
    case priceReversed
}

class HomeViewModel: ObservableObject {
    @Published var allCoins = [CoinModel]()
    @Published var potfolioCoins = [CoinModel]()
    @Published var statistics: [StatisticModel] = []
    @Published var searchedText = ""
    @Published var isLoading = false
    @Published var sortOption: SortOption = .holdings

    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()

    var isRank: Bool {
        return sortOption == .rank || sortOption == .rankReversed
    }
    
    var isHoldings: Bool {
        return sortOption == .holdings || sortOption == .holdingsReversed
    }
    
    var isPrice: Bool {
        return sortOption == .price || sortOption == .priceReversed
    }
    
    init() {
        addSubscriber()
    }
    
    private func addSubscriber() {
        $searchedText
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .map(searchAndSortCoins)
            .sink { [weak self] coins in
                guard let strongSelf = self else { return }
                strongSelf.allCoins = coins
            }
            .store(in: &cancellables)

        $allCoins
            .combineLatest(portfolioDataService.$savedEntities) // the entity binding wait until we receive allCoins
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] coins in
                guard let strongSelf = self else { return }
                strongSelf.potfolioCoins = strongSelf.sortPortfolioCoins(coins: coins)
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
    
    private func searchAndSortCoins(text: String, coins: [CoinModel], sortOption: SortOption) -> [CoinModel] {
        var filteredCoins = searchCoins(text: text, coins: coins)
        sortCoins(sortOption: sortOption, coins: &filteredCoins)
        return filteredCoins
    }
 
    private func searchCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        let searchedCoins = text.isEmpty ? coins : coins.filter {
            $0.name.range(of: text, options: .caseInsensitive) != nil ||
            $0.symbol.range(of: text, options: .caseInsensitive) != nil ||
            $0.id.range(of: text, options: .caseInsensitive) != nil
        }
        return searchedCoins
    }

    private func sortCoins(sortOption: SortOption, coins: inout [CoinModel]) { // take [CoinModel] and give [CoinModel], so we call that inout
         switch sortOption {
         case .rank, .holdings:
             coins.sort(by: { $0.rank < $1.rank })
         case .rankReversed, .holdingsReversed:
             coins.sort(by: { $0.rank > $1.rank })
         case .price:
             coins.sort(by: { $0.currentPrice > $1.currentPrice })
         case .priceReversed:
             coins.sort(by: { $0.currentPrice < $1.currentPrice })
         }
     }

    private func sortPortfolioCoins(coins: [CoinModel]) -> [CoinModel] {
        switch sortOption {
        case .holdings:
            return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
        case .holdingsReversed:
            return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue })
        default:
            return coins
        }
    }
    
    func reloadData() {
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getMarketData()
        HapticManager.notification(type: .success)
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
