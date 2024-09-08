import SwiftUI

struct ChallengesView: View {
    @State var challengesVM = ChallengesVM()
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                CustomHeader(title: "Challenges")
                    .padding(.horizontal)
                
                ScrollSelector(activeSelection: $challengesVM.activeType) { $0.rawValue.capitalized }
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(challengesVM.filteredChallenges) { challenge in
                        ChallengeCard(challenge: challenge)
                    }
                }
                .padding(.horizontal)
            }
        }
        .task {
            await challengesVM.getChallenges()
        }
        .navigationBarBackButtonHidden()
        .background(Color.backgroundGradient)
        .scrollBounceBehavior(.basedOnSize)
        .scrollIndicators(.hidden)
    }
}

#Preview {
    ChallengesView(challengesVM: ChallengesVM(interactor: TestInteractor()))
        .preferredColorScheme(.dark)
        .namespace(Namespace().wrappedValue)
}

