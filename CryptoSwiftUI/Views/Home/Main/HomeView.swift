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
    @State private var searchedText = ""

    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            VStack {
                homeHeaderView
                HomeStatisticsView(showPortfolio: $showPortfolio)
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
        .searchable(text: $searchedText, prompt: "Search by name or symbol...")
        .onChange(of: searchedText) {
            homeViewModel.applyFilter(text: searchedText)
        }
        .sheet(isPresented: $showPortfolioSheet) {
            PortfolioView()
                .environmentObject(homeViewModel)
        }
    }
}

#Preview {
    NavigationView {
        HomeView()
            .environmentObject(DeveloperPreview.instance.homeViewModel)
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
            ForEach(homeViewModel.coins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var portfolioCoinsListView: some View {
        List {
            ForEach(homeViewModel.potfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var columnTitles: some View {
        HStack {
            Text("Coin")
            Spacer()
            if showPortfolio {
                Text("Holdings")
            }
            Spacer()
            Text("Price")
        }
        .padding(.horizontal)
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
    }
}
