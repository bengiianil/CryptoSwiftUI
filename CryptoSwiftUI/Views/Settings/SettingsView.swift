//
//  SettingsView.swift
//  CryptoSwiftUI
//
//  Created by Bengi Anıl on 24.05.2024.
//

import SwiftUI

struct SettingsView: View {
    let githubUrl = URL(string: "https://github.com/bengiianil")!
    let coinUrl = URL(string: "https://www.coingecko.com")!

    var body: some View {
        NavigationView {
            List {
                developerSection
                coinSection
            }
            .font(.headline)
            .tint(Color.blue)
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    CloseButton()
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}

extension SettingsView {
    
    private var  developerSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was developed by Bengi Anıl. It uses SwiftUI and is written 100% in Swift.It uses MVVM Architecture, Combine, and CoreData. The project benefits from multi-threading, publishers/subscribers, and data persistance.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Visit GitHub 🙌", destination: githubUrl)
        } header: {
            Text("Bengi Anıl")
        }
    }
    
    private var  coinSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("The cryptocurrency data that is used in this app comes from a free API from CoinGecko! Prices may be slightly delayed.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Visit CoinGecko 🦎", destination: coinUrl)
        } header: {
            Text("Coin Gecko")
        }
    }
}
