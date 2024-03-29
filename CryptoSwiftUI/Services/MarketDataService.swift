//
//  MarketDataService.swift
//  CryptoSwiftUI
//
//  Created by Bengi Anıl on 28.03.2024.
//

import Combine
import Foundation

class MarketDataService {
    @Published var marketData: MarketDataModel? = nil
    var cancellables = Set<AnyCancellable>()
    
    init() {
        getMarketData()
    }
    
    func getMarketData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }

        NetworkManager.fetchData(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .replaceError(with: GlobalData(data: nil))
            .sink(receiveCompletion: { (completion) in
                NetworkManager.handleCompletion(completion: completion)
            }, receiveValue: { [weak self] globalData in
                self?.marketData = globalData.data
            })
            .store(in: &cancellables)
    }
}
