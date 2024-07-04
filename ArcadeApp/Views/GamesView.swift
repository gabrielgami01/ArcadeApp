//
//  GamesView.swift
//  ArcadeApp
//
//  Created by Gabriel Garcia Millan on 2/7/24.
//

import SwiftUI

struct GamesView: View {
    let master: Master
    
    @Environment(GamesVM.self) private var gamesVM
    
    var body: some View {
        ZStack {
            GamesListView(master: master)
                .opacity(gamesVM.selectedGame == nil ? 1.0 : 0.0)
            if let game = gamesVM.selectedGame {
                GameDetailsView(game: game)
                    .opacity(gamesVM.selectedGame == nil ? 0.0 : 1.0)
            }
        }
    }
}

#Preview {
    NavigationStack {
        GamesView(master: Console.test)
            .environment(GamesVM(interactor: TestInteractor()))
            .preferredColorScheme(.dark)
    }
}
