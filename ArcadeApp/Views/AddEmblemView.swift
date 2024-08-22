import SwiftUI

struct AddEmblemView: View {
    @Environment(\.dismiss) private var dismiss
    @State var challengesVM: ChallengesVM
    
    var body: some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                LabeledHeader(title: "Completed challenges")
                    .padding(.horizontal)
            
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(challengesVM.disponibleChallenges) { challenge in
                        Button {
                            if let selectedEmblem = challengesVM.selectedEmblem {
                                challengesVM.addEmblem(id: challenge.id)
                                challengesVM.deleteEmblem(id: selectedEmblem.id)
                            } else {
                                challengesVM.addEmblem(id: challenge.id)
                            }
                            dismiss()
                        } label: {
                            ChallengeFrontCard(challenge: challenge, showCheck: false)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            challengesVM.getCompletedChallenges()
        }
        .navigationBarBackButtonHidden()
        .scrollIndicators(.hidden)
        .scrollBounceBehavior(.basedOnSize)
        .background(Color.background)
    }
}

#Preview {
    AddEmblemView(challengesVM: ChallengesVM(interactor: TestInteractor()))
}
