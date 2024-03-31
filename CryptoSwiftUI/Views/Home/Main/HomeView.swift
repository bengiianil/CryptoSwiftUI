//
//  HomeView.swift
//  CryptoSwiftUI
//
//  Created by Bengi Anıl on 26.03.2024.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @State private var showPortfolio = false
    @State private var showPortfolioSheet = false
    @State private var showDetailView = false
    @State private var selectedCoin: CoinModel? = nil

    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            VStack {
                homeHeaderView
                HomeStatisticsView(showPortfolio: $showPortfolio)
                SearchBarView(searchedText: $homeViewModel.searchedText)

                columnTitles
                if !showPortfolio {
                    allCoinsListView
                        .transition(.move(edge: .leading))
                } else {
                    portfolioCoinsListView
                        .transition(.move(edge: .trailing))
                }
                
                Spacer()
            }
        }
        .sheet(isPresented: $showPortfolioSheet) {
            PortfolioView()
                .environmentObject(homeViewModel)
        }
        .background(
            NavigationLink(destination: DetailLoadingView(coin: $selectedCoin),
                           isActive: $showDetailView,
                           label: { EmptyView() })
        )
    }
}

#Preview {
    NavigationView {
        HomeView()
            .environmentObject(Preview.instance.homeViewModel)
    }
}

extension HomeView {
    private var homeHeaderView: some View {
        HStack {
            CircleButton(imageName: showPortfolio ? "plus" : "info")
                .animation(.none, value: showPortfolio)
                .background(CircleButtonAnimation(animate: $showPortfolio))
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioSheet.toggle()
                    }
                }
            Spacer()
            
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .bold()
                .foregroundStyle(Color.theme.accent)
                .animation(.none, value: showPortfolio)

            Spacer()

            CircleButton(imageName: "chevron.right")
                .rotationEffect(.degrees(showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
    }
    
    private var allCoinsListView: some View {
        List {
            ForEach(homeViewModel.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var portfolioCoinsListView: some View {
        List {
            ForEach(homeViewModel.potfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private func segue(coin: CoinModel) {
        selectedCoin = coin
        showDetailView.toggle()
    }
    
    private var columnTitles: some View {
        HStack {
            HStack(spacing: 4) {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity(homeViewModel.isRank ? 1 : 0)
                    .rotationEffect(Angle(degrees: homeViewModel.sortOption == .rank ? 0: 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    homeViewModel.sortOption = homeViewModel.sortOption == .rank ? .rankReversed : .rank
                }
            }

            Spacer()
            
            if showPortfolio {
                HStack(spacing: 4) {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity(homeViewModel.isHoldings ? 1 : 0)
                        .rotationEffect(Angle(degrees: homeViewModel.sortOption == .holdings ? 0: 180))
                }
                .onTapGesture {
                    withAnimation(.default) {
                        homeViewModel.sortOption = homeViewModel.sortOption == .holdings ? .holdingsReversed : .holdings
                    }
                }
            }
            
            Spacer()
            
            HStack(spacing: 4) {
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity(homeViewModel.isPrice ? 1 : 0)
                    .rotationEffect(Angle(degrees: homeViewModel.sortOption == .price ? 0: 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    homeViewModel.sortOption = homeViewModel.sortOption == .price ? .priceReversed : .price
                }
            }
            
            Button {
                withAnimation(.linear(duration: 2)) {
                    homeViewModel.reloadData()
                }
            } label: {
                Image(systemName: "goforward")
            }
            .rotationEffect(Angle(degrees: homeViewModel.isLoading ? 360 : 0), anchor: .center)

        }
        .padding(.horizontal)
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
    }
}
