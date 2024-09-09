import SwiftUI

struct ChallengesView: View {
    @State var challengesVM = ChallengesVM()
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 10, pinnedViews: [.sectionHeaders]) {
                Section {
                    ScrollSelector(activeSelection: $challengesVM.activeType) { $0.rawValue.capitalized }
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(challengesVM.filteredChallenges) { challenge in
                            ChallengeCard(challenge: challenge)
                        }
                    }
                    .padding(.horizontal)
                } header: {
                    HStack(alignment: .firstTextBaseline, spacing: 20) {
                        BackButton {
                            dismiss()
                        }
                        Text("Challenges")
                            .font(.customLargeTitle)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.bottom, 5)
                    .background {
                        Rectangle()
                            .fill(Color.background)
                            .padding(.top, -UIDevice.topInset)
                    }
                }
            }
        }
        .task {
            await challengesVM.getChallenges()
        }
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

