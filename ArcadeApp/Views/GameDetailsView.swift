import SwiftUI

enum PickerOptions: String, Identifiable, CaseIterable {
    case review = "Reviews"
    case score = "My scores"
    
    var id: Self { self }
}

struct GameDetailsView: View {
    let namespace: Namespace.ID
    
    @State var detailsVM: GameDetailsVM
    @State private var option: PickerOptions = .review
    @Environment(GamesVM.self) private var gamesVM
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Button {
                gamesVM.selectedGame = nil
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title)
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
            .padding(.bottom, 5)
            
            GeometryReader {
                let size = $0.size
                
                HStack(spacing: 5) {
                    GameCover(game: detailsVM.game, namespace: namespace, width: size.width / 2.5, height: size.height)
                    GameDetailsCard(detailsVM: detailsVM, namespace: namespace)
                            .frame(height: size.height)
                    }

                }
                .frame(height: 220)
            
            VStack(spacing: 10) {
                Picker(selection: $option) {
                    ForEach(PickerOptions.allCases) { option in
                        Text(option.rawValue)
                            .font(.body)
                    }
                } label: {
                    Text("Options")
                }
                .pickerStyle(.segmented)
                
                ZStack {
                    ReviewList(detailsVM: detailsVM)
                        .opacity(option == .review ? 1.0 : 0.0)
                    
                }

            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .task {
            await detailsVM.loadGameDetails()
        }
        .toolbar(.hidden)
        .sheet(isPresented: $detailsVM.showAddReview) {
            AddReviewView(addReviewVM: AddReviewVM(game: detailsVM.game))
        }
    }
}

#Preview {
    GameDetailsView(namespace: Namespace().wrappedValue, detailsVM: GameDetailsVM(interactor: TestInteractor(), game: .test))
        .environment(GamesVM(interactor: TestInteractor()))
}

struct GameDetailsCard: View {
    @State var detailsVM: GameDetailsVM
    let namespace: Namespace.ID
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(detailsVM.game.name)
                .font(.headline)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .matchedGeometryEffect(id: "\(detailsVM.game.id)-name", in: namespace)
            Text("Release date: \(detailsVM.game.releaseDate.formatted(date: .abbreviated, time: .omitted))")
                .font(.caption)
                .foregroundStyle(.secondary)
            HStack(alignment: .lastTextBaseline, spacing: 5) {
                RatingComponent(rating: .constant(Int(detailsVM.globalRating)), mode: .display)
                Text("(\(detailsVM.globalRating.formatted(.number.precision(.fractionLength(1)))))")
                    .font(.caption)
                    .foregroundStyle(.yellow)
            }
            HStack {
                Button {
                    detailsVM.useFavorite()
                } label: {
                    Image(systemName: "heart")
                        .font(.title2)
                        .symbolVariant(detailsVM.favorite ? .fill : .none)
                        .tint(detailsVM.favorite ? .red : .blue)
                }
                Text("Like")
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
        }
        
    }
}

struct ReviewList: View {
    @State var detailsVM: GameDetailsVM
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                HStack {
                    Text("Player Reviews")
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
                        .font(.body)
                    }
                }
                .padding(.vertical, 5)
                
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
            .padding(.horizontal)
        }
    }
}


