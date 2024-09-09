import SwiftUI

struct ChallengesView: View {
    @State var challengesVM = ChallengesVM()
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                LazyVGrid(columns: columns, spacing: 20, pinnedViews: [.sectionHeaders]) {
                    Section {
                        ForEach(challengesVM.filteredChallenges) { challenge in
                            ChallengeCard(challenge: challenge)
                        }
                        
                    } header: {
                        VStack {
                            CustomHeader(title: "Challenges")
                                .padding(.horizontal)
                            ScrollSelector(activeSelection: $challengesVM.activeType) { $0.rawValue.capitalized }
                        }
                        .padding(.bottom, 5)
                        .background(Color.background)
                        
                    }
                }
                
            }
        }
        .task {
            await challengesVM.getChallenges()
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarBackButtonHidden()
        .background(Color.background)
        .scrollBounceBehavior(.basedOnSize)
        .scrollIndicators(.hidden)
    }
}

#Preview {
    ChallengesView(challengesVM: ChallengesVM(interactor: TestInteractor()))
        .preferredColorScheme(.dark)
        .namespace(Namespace().wrappedValue)
}

