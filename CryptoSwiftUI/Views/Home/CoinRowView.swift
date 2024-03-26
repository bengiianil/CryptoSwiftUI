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
        .padding()
        .font(.subheadline)
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        CoinRowView(coin: dev.coin, showHoldingsColumn: true)
    }
}

extension CoinRowView {
    private var leftColumn: some View {
        HStack {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
                .frame(minWidth: 30)
            
            Image(coin.image)
            
            
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
            }
        }
    }
}
