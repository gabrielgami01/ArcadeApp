import SwiftUI

struct GameAboutView: View {
    @State var detailsVM: GameDetailsVM
    let namespace: Namespace.ID
    
    var body: some View {
        VStack {
            GeometryReader {
                let size = $0.size
                
                HStack(spacing: 5) {
                    GameCover(game: detailsVM.game, width: size.width / 2.5, height: size.height, namespace: namespace)
                    GameDetailsCard(detailsVM: detailsVM, namespace: namespace)
                            .frame(height: size.height)
                    }

                }
                .frame(height: 220)
            
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
                        ReviewCell(review: review)
                        Divider()
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    GameAboutView(detailsVM: GameDetailsVM(interactor: TestInteractor(), game: .test),
                   namespace: Namespace().wrappedValue)
}
