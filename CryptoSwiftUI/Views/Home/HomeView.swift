//
//  HomeView.swift
//  CryptoSwiftUI
//
//  Created by Bengi Anıl on 26.03.2024.
//

import SwiftUI

struct HomeView: View {
    @State var searchedText = ""
    @State var showPortfolio = false
    @State var coins = ["coin1", "coin2", "coin3", "coin4"]

    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            ScrollView {

                homeHeaderView
                
                List(coins, id: \.self) { coin in
                    Text("coin")
                        .foregroundStyle(Color.theme.accent)

                    Text(coin)
                        .foregroundStyle(Color.theme.accent)

                }
                
            }
            .searchable(text: $searchedText, prompt: "Search by name or symbol...")
        }
    }
}

#Preview {
    NavigationView {
        HomeView()
            .navigationBarBackButtonHidden()
    }
}

extension HomeView {
    private var homeHeaderView: some View {
        HStack {
            CircleButton(imageName: showPortfolio ? "plus" : "info")
                .animation(.none, value: showPortfolio)
                .background(CircleButtonAnimation(animate: $showPortfolio))
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
        .padding()
    }
}
