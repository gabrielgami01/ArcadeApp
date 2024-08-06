import SwiftUI

struct GameAboutView: View {
    @State var detailsVM: GameDetailsVM
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                GeometryReader { geometry in
                    let size = geometry.size

                    HStack(spacing: 10) {
                        GameCoverCard(game: detailsVM.game, width: size.width, height: size.height)
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
                    CustomUnavailableView(title: "No reviews", image: "gamecontroller", description: "There isn't any review for this game yet.")
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

