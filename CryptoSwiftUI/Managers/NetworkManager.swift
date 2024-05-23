//
//  NetworkManager.swift
//  CryptoSwiftUI
//
//  Created by Bengi Anıl on 27.03.2024.
//

import Combine
import Foundation

class NetworkManager {

    static func fetchData(url: URL) -> AnyPublisher<Data, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { (output) -> Data in
                try handleUrlResponse(output: output)
            }
            .eraseToAnyPublisher()
    }
    
    static func handleUrlResponse(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        print("Status Code: \(response.statusCode)")
        print(output.data)
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
