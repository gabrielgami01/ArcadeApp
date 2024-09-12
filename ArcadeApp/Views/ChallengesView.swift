import SwiftUI

struct ChallengesView: View {
    @State var challengesVM = ChallengesVM()
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        let columns = [GridItem(.flexible(), spacing: 10), GridItem(.flexible())]
        
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ScrollSelector(activeSelection: $challengesVM.activeType) { $0.rawValue.capitalized }
                
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(challengesVM.filteredChallenges) { challenge in
                        ChallengeCard(challenge: challenge)
                    }
                    .animation(.none, value: challengesVM.activeType)
                }
                .padding(.horizontal)
            }
        }
        .task {
            await challengesVM.getChallenges()
        }
        .headerToolbar(title: "Challenges") { dismiss() }  
        .padding(.top, 5)
        .scrollBounceBehavior(.basedOnSize)
        .scrollIndicators(.hidden)
        .background(Color.background)
    }
}

#Preview {
    NavigationStack {
        ChallengesView(challengesVM: ChallengesVM(interactor: TestInteractor()))
            .preferredColorScheme(.dark)
            .namespace(Namespace().wrappedValue)
    }
}




