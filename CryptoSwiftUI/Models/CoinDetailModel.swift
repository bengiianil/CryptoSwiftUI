//
//  CoinDetailModel.swift
//  CryptoSwiftUI
//
//  Created by Bengi Anıl on 31.03.2024.
//

import Foundation

struct CoinDetailModel: Codable {
    let id, symbol, name: String?
    let blockTimeInMinutes: Int?
    let hashingAlgorithm: String?
    let description: Description?
    let links: Links?
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, description, links
        case blockTimeInMinutes = "block_time_in_minutes"
        case hashingAlgorithm = "hashing_algorithm"
    }
    
//    var readableDescription: String? {
//        return description?.en?.removingHTMLOccurances
//    }
    
    init(id: String?, symbol: String?, name: String?, blockTimeInMinutes: Int?, hashingAlgorithm: String?, description: Description?, links: Links?) {
        self.id = id
        self.symbol = symbol
        self.name = name
        self.blockTimeInMinutes = blockTimeInMinutes
        self.hashingAlgorithm = hashingAlgorithm
        self.description = description
        self.links = links
    }
}

struct Links: Codable {
    let homepage: [String]?
    let subredditURL: String?
    
    enum CodingKeys: String, CodingKey {
        case homepage
        case subredditURL = "subreddit_url"
    }
}

struct Description: Codable {
    let en: String?
}
