import SwiftUI

struct GameAboutView: View {
    @State var detailsVM: GameDetailsVM
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                GeometryReader { geometry in
                    let size = geometry.size

                    HStack(spacing: 10) {
                        GameCover(game: detailsVM.game, width: size.width / 2.5, height: size.height)
                        GameDetailsCard(detailsVM: detailsVM)
                            .frame(height: size.height)
                    }
                }
                .frame(height: 220)
                   
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
