//
//  CryptoPlumberApp.swift
//  CryptoPlumber
//
//  Created by Ruben Sopra on 19/7/22.
//

import SwiftUI


@main
struct CryptoPlumberApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
        }
    }
}
