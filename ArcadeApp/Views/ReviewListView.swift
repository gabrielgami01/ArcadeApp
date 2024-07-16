import SwiftUI

struct ReviewListView: View {
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
                    ReviewCell(review: review)
                    Divider()
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    ReviewListView(detailsVM: GameDetailsVM(interactor: TestInteractor(), game: .test))
}
