//
//  GamesListView.swift
//  ArcadeApp
//
//  Created by Gabriel Garcia Millan on 26/6/24.
//

import SwiftUI

struct GamesListView: View {
    let item: GenreConsole
    
    @Environment(SearchVM.self) private var searchVM
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(searchVM.games) { game in
                    Text(game.name)
                }
            }
        }
        .task {
            await searchVM.getGamesByGenreConsole(item: item)
        }
    }
}

#Preview {
    GamesListView(item: Console.test)
}
