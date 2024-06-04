//
//  CoinDetailDataService.swift
//  CryptoSwiftUI
//
//  Created by Bengi Anıl on 31.03.2024.
//

import Combine
import Foundation

class CoinDetailDataService {
    @Published var coinDetails: CoinDetailModel?
    var cancellables = Set<AnyCancellable>()
    let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        getCoinDetails(coin: coin)
    }
    
    func getCoinDetails(coin: CoinModel) {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else { return }

        NetworkManager.fetchData(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (completion) in
                NetworkManager.handleCompletion(completion: completion)
            }, receiveValue: { [weak self] coinDetails in
                self?.coinDetails = coinDetails
            })
            .store(in: &cancellables)
    }
}
