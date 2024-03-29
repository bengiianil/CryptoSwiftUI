//
//  ImageViewModel.swift
//  CryptoSwiftUI
//
//  Created by Bengi Anıl on 27.03.2024.
//

import Combine
import Foundation
import SwiftUI

class ImageViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var isLoading = true
    private let coin: CoinModel
    private let coinImageService: CoinImageService
    private var cancellables = Set<AnyCancellable>()

    init(coin: CoinModel) {
        self.coin = coin
        self.coinImageService = CoinImageService(coin: coin)
        addSubscriber()
    }
    
    private func addSubscriber() {
        coinImageService.$image.sink { [weak self] image in
            guard let strongSelf = self else { return }
            strongSelf.image = image
            strongSelf.isLoading = false
        }
        .store(in: &cancellables)
    }
}
