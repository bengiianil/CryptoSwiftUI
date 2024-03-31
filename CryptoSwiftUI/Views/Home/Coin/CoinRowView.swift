//
//  CoinRowView.swift
//  CryptoSwiftUI
//
//  Created by Bengi Anıl on 26.03.2024.
//

import SwiftUI

struct CoinRowView: View {
    let coin: CoinModel
    let showHoldingsColumn: Bool

    var body: some View {
        HStack {
            leftColumn
            Spacer()
            if showHoldingsColumn {
                centerColumn
            }
            Spacer()
            rightColumn
        }
        .font(.subheadline)
        .background(
            Color.theme.background
        )
    }
}

#Preview {
    CoinRowView(coin: Preview.instance.coin, showHoldingsColumn: true)
}

extension CoinRowView {
    private var leftColumn: some View {
        HStack {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
                .frame(minWidth: 30)
 
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
        }
    }
    
    private var centerColumn: some View {
        HStack {
            VStack(alignment: .trailing) {
                Text(coin.currentHoldingsValue.currencyToString())
                    .bold()
                
                let holdings = coin.currentHoldings ?? 0
                Text(holdings.doubleToString())
            }
            .foregroundStyle(Color.theme.accent)
        }
    }
    
    private var rightColumn: some View {
        HStack {
            VStack(alignment: .trailing) {
                Text(coin.currentPrice.currencyToString())
                    .bold()
                    .foregroundStyle(Color.theme.accent)
                
                let percentage = coin.priceChangePercentage24H ?? 0
                Text(percentage.percentString())
                    .foregroundStyle(percentage >= 0 ? Color.theme.green : Color.theme.red)
                    .font(.subheadline)
            }
        }
    }
}
