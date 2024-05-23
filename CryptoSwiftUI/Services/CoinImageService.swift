//
//  CoinImageService.swift
//  CryptoSwiftUI
//
//  Created by Bengi Anıl on 27.03.2024.
//

import Combine
import Foundation
import SwiftUI

class CoinImageService {
    @Published var image: UIImage? = nil
    var cancellables = Set<AnyCancellable>()
    private let coin: CoinModel
    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_images"
    private let imageName: String
    
    init(coin: CoinModel) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage() {
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            image = savedImage
        } else {
            fetchCoinImage()
        }
    }
    
    private func fetchCoinImage() {
        guard let url = URL(string: coin.image) else { return }
        
        NetworkManager.fetchData(url: url)
            .tryMap { (data) -> UIImage? in
                return UIImage(data: data)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (completion) in
                NetworkManager.handleCompletion(completion: completion)
            }, receiveValue: { [weak self] image in
                guard let strongSelf = self, 
                      let image = image else { return }
                strongSelf.image = image
                strongSelf.fileManager.saveImage(image: image, imageName: strongSelf.imageName, folderName: strongSelf.folderName)
            })
            .store(in: &cancellables)
    }
}
