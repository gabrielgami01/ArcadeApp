import SwiftUI

struct AddEmblemView: View {
    @Environment(\.dismiss) private var dismiss
    @State var challengesVM: ChallengesVM
    
    var body: some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if challengesVM.disponibleChallenges.count > 0 {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(challengesVM.disponibleChallenges) { challenge in
                                Button {
                                    if let selectedEmblem = challengesVM.selectedEmblem {
                                        challengesVM.deleteEmblem(id: selectedEmblem.id)
                                        challengesVM.addEmblem(id: challenge.id)
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
                    } else {
                        CustomUnavailableView(title: "No available emblems", image: "trophy",
                                              description: "You don't have available emblems by the moment")
                    }
                }
            }
            .task {
                await challengesVM.getCompletedChallenges()
            }
            .sheetToolbar(title: "Emblems", confirmationLabel: nil, confirmationAction: nil)
            .navigationBarBackButtonHidden()
            .background(Color.background)
            .scrollIndicators(.hidden)
            .scrollBounceBehavior(.basedOnSize)
        }
        
    }
}

#Preview {
    AddEmblemView(challengesVM: ChallengesVM(interactor: TestInteractor()))
}
