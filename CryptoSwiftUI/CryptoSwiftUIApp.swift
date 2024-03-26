//
//  CryptoSwiftUIApp.swift
//  CryptoSwiftUI
//
//  Created by Bengi Anıl on 26.03.2024.
//

import SwiftUI

@main
struct CryptoSwiftUIApp: App {
    @StateObject private var homeViewModel = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarBackButtonHidden()
            }
            .environmentObject(homeViewModel)
        }
    }
}
