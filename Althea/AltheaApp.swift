//
//  AltheaApp.swift
//  Althea
//
//  Created by Theresa Tiffany on 21/06/23.
//

import SwiftUI

@main
struct AltheaApp: App {
    var body: some Scene {
        let game = RealTimeGame.shared
        WindowGroup {
//            LandingPageView()
//                .environmentObject(game)
            ArchieView(scene: ArchieScene()).environmentObject(game)
        }
    }
}
