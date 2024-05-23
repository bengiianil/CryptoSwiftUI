//
//  CoinDataService.swift
//  CryptoSwiftUI
//
//  Created by Bengi Anıl on 26.03.2024.
//

import Combine
import Foundation

class CoinDataService {
    @Published var allCoins = [CoinModel]()
    var cancellables = Set<AnyCancellable>()
    
    init() {
        getCoins()
    }
    
    func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else { return }
        
        // Combine Rules:
        /*
        // 1. sign up for monthly subscription for package to be delivered
        // 2. the company would make the package behind the scene
        // 3. recieve the package at your front door
        // 4. make sure the box isn't damaged
        // 5. open and make sure the item is correct
        // 6. use the item!!!!
        // 7. cancellable at any time!!
        
        // 1. create the publisher
        // 2. subscribe publisher on background thread
        // 3. recieve on main thread
        // 4. tryMap (check that the data is good)
        // 5. decode (decode data into PostModels)
        // 6. sink (put the item into our app)
        // 7. store (cancel subscription if needed)
        */
        
        NetworkManager.fetchData(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (completion) in
                NetworkManager.handleCompletion(completion: completion)
            }, receiveValue: { [weak self] coins in
                self?.allCoins = coins
            })
            .store(in: &cancellables)
    }
}
