import SwiftUI

struct ChallengesView: View {
    @Environment(\.dismiss) private var dismiss
    @State var challengesVM = ChallengesVM()
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                LabeledHeader(title: "Challenges")
                    .padding(.horizontal)
                
                ScrollSelector(activeSelection: $challengesVM.activeType) { $0.rawValue.capitalized }
            
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(challengesVM.challenges) { challenge in
                        ChallengeCard(challenge: challenge)
                    }
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            challengesVM.getChallenges()
        }
        .animation(.easeInOut, value: challengesVM.challenges)
        .onChange(of: challengesVM.activeType) { oldValue, newValue in
            challengesVM.getChallenges(type: newValue)
        }
        .navigationBarBackButtonHidden()
        .scrollIndicators(.hidden)
        .scrollBounceBehavior(.basedOnSize)
        .background(Color.background)
    }
}

#Preview {
    ChallengesView(challengesVM: ChallengesVM(interactor: TestInteractor()))
        .namespace(Namespace().wrappedValue)
}

