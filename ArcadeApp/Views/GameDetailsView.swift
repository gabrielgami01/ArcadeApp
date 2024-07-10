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
    @State var detailsVM = GameDetailsVM()
    
    @State private var globalRating = 4
    
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
                            detailsVM.useFavorite(gameID: game.id)
                        } label: {
                            Image(systemName: "heart")
                                .font(.title2)
                                .symbolVariant(detailsVM.favorite ? .fill : .none)
                                .tint(detailsVM.favorite ? .red : .white)
                        }
                    }
                    
                    HStack(alignment: .bottom, spacing: 20) {
                        RatingComponent(rating: .constant(Int(detailsVM.globalRating)), mode: .display)
                        Text("\(detailsVM.reviews.count) reviews")
                            .font(.footnote)
                    }

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
                    HStack {
                        Text("Player's Reviews")
                            .font(.title3)
                            .bold()
                        Spacer()
                        Button {
                            detailsVM.showAddReview.toggle()
                        } label: {
                            Label {
                                Text("Write a Review")
                            } icon: {
                                Image(systemName: "square.and.pencil")
                            }
                            .font(.headline)
                        }
                    }
                    LazyVStack(alignment: .leading) {
                        ForEach(detailsVM.reviews) { review in
                            HStack(alignment: .top, spacing: 20) {
                                if let avatar = review.avatarURL {
                                } else {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50)
                                }
                                VStack(alignment: .leading) {
                                    Text(review.username)
                                        .font(.headline)
                                    HStack(spacing: 20) {
                                        RatingComponent(rating: .constant(review.rating), mode: .display)
                                        Text(review.date.formatted())
                                            .font(.footnote)
                                    }
                                    .padding(.bottom, 5)
                                    Text(review.title)
                                        .font(.headline)
                                    if let comment = review.comment {
                                        Text(comment)
                                            .font(.subheadline)
                                    }
                                }
                            }
                            Divider()
                        }
                    }
                }
                .padding([.horizontal, .top])
                
            }
            
        }
        .task {
            await detailsVM.loadGameDetails(id: game.id)
        }
        .sheet(isPresented: $detailsVM.showAddReview){
            AddReviewView(addReviewVM: AddReviewVM(game: game))
        }
        .ignoresSafeArea(edges: .top)
        .background(Color("backgroundColor").gradient)
        .overlay(alignment: .topLeading) {
            Button {
                gamesVM.selectedGame = nil
            } label: {
                Image(systemName: "chevron.left")
                    .font(.largeTitle)
            }
            .buttonStyle(.plain)
            .foregroundStyle(.white)
            .padding(.leading)
        }
        .toolbar(.hidden)
        
    }
}

#Preview {
    GameDetailsView(game: .test, detailsVM: GameDetailsVM(interactor: TestInteractor()))
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
