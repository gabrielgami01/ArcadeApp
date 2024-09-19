import SwiftUI

struct ChallengesView: View {
    @Environment(ChallengesVM.self) private var challengesVM
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        @Bindable var challengesBVM = challengesVM
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                ScrollSelector(selected: $challengesBVM.activeType, displayKeyPath: \.rawValue)
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(challengesVM.filteredChallenges) { challenge in
                        ChallengeCard(challenge: challenge)
                    }
                }
                .padding(.horizontal)
            }
        }
        .refreshable {
            Task {
                await challengesVM.getChallenges()
            }
        }
        .headerToolbar(title: "Challenges") { dismiss() }
        .scrollBounceBehavior(.basedOnSize)
        .scrollIndicators(.hidden)
        .background(Color.background)
    }
}

#Preview {
    NavigationStack {
        ChallengesView()
            .environment(ChallengesVM(interactor: TestInteractor()))
            .preferredColorScheme(.dark)
            .namespace(Namespace().wrappedValue)
    }
}




