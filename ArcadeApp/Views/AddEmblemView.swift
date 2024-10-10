import SwiftUI

struct AddEmblemView: View {
    @Environment(ChallengesVM.self) private var challengesVM
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        
        NavigationStack {
            ScrollView {
                if !challengesVM.disponibleChallenges.isEmpty {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(challengesVM.disponibleChallenges) { challenge in
                            Button {
                                if let selectedEmblem = challengesVM.selectedEmblem {
                                    Task {
                                        if await challengesVM.updateEmblemAPI(newChallenge: challenge.id, oldChallenge: selectedEmblem.challenge.id) {
                                            let updatedEmblem = Emblem(id: selectedEmblem.id, challenge: challenge)
                                            challengesVM.updateEmblem(updatedEmblem)
                                            dismiss()
                                        }
                                    }
                                } else {
                                    Task {
                                        if await challengesVM.addEmblemAPI(challengeID: challenge.id) {
                                            let newEmblem = Emblem(id: UUID(), challenge: challenge)
                                            challengesVM.addEmblem(newEmblem)
                                            dismiss()
                                        }
                                    }
                                }
                            } label: {
                                ChallengeFrontCard(challenge: challenge, showCheck: false)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                } else {
                    CustomUnavailableView(title: "No available emblems", image: "trophy",
                                          description: "You haven't any available emblems by the moment.")
                }
            }
            .sheetToolbar(title: "Emblems", confirmationLabel: nil, confirmationAction: nil)
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal)
            .background(Color.background)
            .scrollIndicators(.hidden)
            .scrollBounceBehavior(.basedOnSize)
        }
        
    }
}

#Preview {
    AddEmblemView()
        .environment(ChallengesVM(interactor: TestInteractor()))
        .preferredColorScheme(.dark)
}
