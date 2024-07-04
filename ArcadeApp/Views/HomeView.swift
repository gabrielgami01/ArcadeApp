//
//  HomeView.swift
//  ArcadeApp
//
//  Created by Gabriel Garcia Millan on 2/7/24.
//

import SwiftUI

struct HomeView: View {
    @Environment(UserVM.self) private var userVM
    @Environment(GamesVM.self) private var gamesVM
    
    var body: some View {
        ZStack {
            LandingHomeView()
                .opacity(gamesVM.selectedGame == nil ? 1.0 : 0.0)
            if let game = gamesVM.selectedGame {
                GameDetailsView(game: game)
                    .opacity(gamesVM.selectedGame == nil ? 0.0 : 1.0)
            }
        }
    }
}

#Preview {
    HomeView()
        .environment(UserVM())
        .environment(GamesVM(interactor: TestInteractor()))
        .preferredColorScheme(.dark)
}
