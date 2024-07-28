import SwiftUI

struct GameAboutView: View {
    @State var detailsVM: GameDetailsVM
    @State private var isFlipped = false

    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                GeometryReader { geometry in
                    let size = geometry.size

                    HStack(spacing: 10) {
                        ZStack {
                            GameCover(game: detailsVM.game, width: size.width / 2.5, height: size.height)
                                .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                                .opacity(isFlipped ? 0 : 1)
                                .shimmerEffect()
                            GameDescriptionCard(game: detailsVM.game)
                                .frame(width: size.width / 2.5, height: size.height)
                                .background {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color(white: 0.95))
                                }
                                .rotation3DEffect(.degrees(isFlipped ? 0 : -180), axis: (x: 0, y: 1, z: 0))
                                .opacity(isFlipped ? 1 : 0)
                            
                        }
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                isFlipped.toggle()
                            }
                         }
                        GameDetailsCard(detailsVM: detailsVM)
                            .frame(height: size.height)
                    }
                }
                .frame(height: 220)
                   
                HStack {
                    Text("Player Reviews")
                        .font(.customTitle3)
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
                        .font(.customBody)
                    }
                }
                .padding(.vertical, 5)
                   
                if !detailsVM.reviews.isEmpty {
                    LazyVStack(alignment: .leading) {
                        ForEach(detailsVM.reviews) { review in
                            ReviewCell(review: review)
                            Divider()
                        }
                    }
                } else {
                    ContentUnavailableView("No reviews", systemImage: "gamecontroller",
                                           description: Text("There isn't any review for this game yet."))
                }
            }
        }
        .sheet(isPresented: $detailsVM.showAddReview) {
            AddReviewView(addReviewVM: AddReviewVM(game: detailsVM.game))
        }
    }
}

#Preview {
    GameAboutView(detailsVM: GameDetailsVM(interactor: TestInteractor(), game: .test))
    .padding()
}

