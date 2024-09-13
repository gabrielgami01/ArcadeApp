import SwiftUI

struct AddEmblemView: View {
    @Environment(\.dismiss) private var dismiss
    @State var emblemsVM: EmblemsVM
    
    var body: some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if emblemsVM.disponibleChallenges.count > 0 {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(emblemsVM.disponibleChallenges) { challenge in
                                Button {
                                    if let selectedEmblem = emblemsVM.selectedEmblem {
                                        Task {
                                            if await emblemsVM.updateEmblemAPI(newChallenge: challenge.id, oldChallenge: selectedEmblem.challenge.id) {
                                                let updatedEmblem = Emblem(id: selectedEmblem.id, challenge: challenge)
                                                emblemsVM.updateEmblem(updatedEmblem)
                                                dismiss()
                                            }
                                        }
                                    } else {
                                        Task {
                                            if await emblemsVM.addEmblemAPI(challengeID: challenge.id) {
                                                let newEmblem = Emblem(id: UUID(), challenge: challenge)
                                                emblemsVM.addEmblem(newEmblem)
                                                dismiss()
                                            }
                                        }
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
                await emblemsVM.getCompletedChallenges()
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
    AddEmblemView(emblemsVM: EmblemsVM(interactor: TestInteractor()))
        .preferredColorScheme(.dark)
}
