//
//  DetailView.swift
//  CryptoSwiftUI
//
//  Created by Bengi Anıl on 31.03.2024.
//

import SwiftUI

struct DetailLoadingView: View {
    @Binding var coin: CoinModel?
    
    init(coin: Binding<CoinModel?>) {
        self._coin = coin
    }
    
    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {
    @StateObject private var detailViewModel: DetailViewModel
    @State private var showFullDescription: Bool = false

    private let columns: [GridItem] = [GridItem(.flexible()),
                                       GridItem(.flexible())]
    private let spacing: CGFloat = 30
    
    
    init(coin: CoinModel) {
        _detailViewModel = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView {
            
            VStack {
                DetailChartView(coin: detailViewModel.coin)
                    .padding(.vertical)
                
                VStack(spacing: 20) {
                    overviewTitle
                    Divider()
                    descriptionSection
                    overviewGrid
                    
                    additionalTitle
                    Divider()
                    additionalGrid
                    
                    websiteSection
                }
                .padding()
            }
        }
        .background(
            Color.theme.background
                .ignoresSafeArea()
        )
        .navigationTitle(detailViewModel.coin.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                navigationBarTrailingItem
            }
        }
    }
}

#Preview {
    NavigationView {
        DetailView(coin: Preview.instance.coin)
    }
}

extension DetailView {
    
    private var navigationBarTrailingItem: some View {
        HStack {
            Text(detailViewModel.coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(Color.theme.secondaryText)
            
            CoinImageView(coin: detailViewModel.coin)
                .frame(width: 25, height: 25)
        }
    }
    
    private var descriptionSection: some View {
        ZStack {
            if let coinDescription = detailViewModel.coinDescription, !coinDescription.isEmpty {
                
                VStack(alignment: .leading) {
                    Text(coinDescription)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundStyle(Color.theme.secondaryText)
                    
                    Button {
                        withAnimation(.easeInOut) {
                            showFullDescription.toggle()
                        }
                    } label: {
                        Text(showFullDescription ? "Less" : "Read more...")
                            .font(.caption)
                            .bold()
                            .padding(.vertical, 4)
                    }
                    .tint(.blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private var overviewTitle: some View {
        Text("Overview")
              .font(.title)
              .bold()
              .foregroundColor(Color.theme.accent)
              .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var overviewGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: [],
            content: {
                ForEach(detailViewModel.overviewStatistics) { statistic in
                    StatisticView(statistic: statistic)
                }
        })
    }
    
    private var additionalTitle: some View {
        Text("Additional Details")
              .font(.title)
              .bold()
              .foregroundColor(Color.theme.accent)
              .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: [],
            content: {
                ForEach(detailViewModel.additionalStatistics) { statistic in
                    StatisticView(statistic: statistic)
                }
        })
    }
    
    private var websiteSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let websiteString = detailViewModel.websiteUrl,
               let websiteUrl = URL(string: websiteString) {
                Link("Website", destination: websiteUrl)
            }
            
            if let redditString = detailViewModel.redditUrl,
               let redditUrl = URL(string: redditString) {
                Link("Reddit", destination: redditUrl)
            }
        }
        .tint(.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
