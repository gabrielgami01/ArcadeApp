//
//  GameView.swift
//  ArcadeApp
//
//  Created by Gabriel Garcia Millan on 28/6/24.
//

import SwiftUI

struct GameDetailsView: View {
    let game: Game
    
    @Environment(GamesVM.self) private var gamesVM
    
    @State private var favorite = false
    @State private var globalRating = 4
    @State private var rating = 0
    @State private var comment = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ZStack {
                    GameCover(game: game, width: .infinity, height: 350)
                        .opacity(0.4)
                    GameCover(game: game, width: 160, height: 260)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 3)
                                .fill(.red)
                        }
                        .offset(y: 10)
                    
                }
                
                VStack (alignment: .leading, spacing: 10) {
                    HStack {
                        Text(game.name)
                            .font(.title2)
                            .bold()
                        Spacer()
                        Button {
                            favorite.toggle()
                        } label: {
                            Image(systemName: "heart")
                                .font(.title2)
                                .symbolVariant(favorite ? .fill : .none)
                                .tint(favorite ? .red : .white)
                        }
                    }
                    
                    RatingComponent(rating: $globalRating, mode: .display)

                    HStack() {
                        if game.featured {
                            Text("Featured")
                                .genreCard
                        }
                        Text(game.genre)
                            .genreCard
                        Text(game.console)
                            .genreCard
                    }
                    .foregroundStyle(.black)
                    .padding(.top, 5)
                }
                .padding([.horizontal, .top])
                
                Text(game.description)
                    .font(.callout)
                    .padding([.horizontal, .top])
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Leave a Review")
                        .font(.title3)
                        .bold()
                    RatingComponent(rating: $rating, mode: .rate)
                    
//                    TextViewUIKit(text: $comment, maxLines: 4)
//                        .frame(height: 100)
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    TextEditor(text: $comment)
                        .lineLimit(4)
                        .scrollContentBackground(.hidden)
                        .foregroundStyle(.black)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(height: 100)
                    
                    CustomButton(label: "Send") {
                        
                    }
                }
                .padding([.horizontal, .top])
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Player's Reviews")
                        .font(.title3)
                        .bold()
                    LazyVStack {
                                    
                    }
                }
                .padding([.horizontal, .top])
                
            }
            
        }
        .ignoresSafeArea(edges: .top)
        .background(Color("backgroundColor"))
        .overlay(alignment: .topLeading) {
            Button {
                gamesVM.selectedGame = nil
            } label: {
                Image(systemName: "chevron.left")
                    .font(.largeTitle)
//                    .symbolVariant(.fill)
//                    .symbolVariant(.circle)
            }
            .buttonStyle(.plain)
            .foregroundStyle(.white)
            .padding(.leading)
        }
        .toolbar(.hidden)
        
    }
}

#Preview {
    GameDetailsView(game: .test)
        .environment(GamesVM(interactor: TestInteractor()))
        .preferredColorScheme(.dark)
}

fileprivate struct GenreCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 70)
            .font(.caption2)
            .padding(5)
            .padding(.horizontal)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.cyan)
            }
            
    }
}

extension View {
    var genreCard: some View {
        modifier(GenreCard())
    }
}
