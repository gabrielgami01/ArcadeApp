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
                                        emblemsVM.deleteEmblem(id: selectedEmblem.id)
                                        emblemsVM.addEmblem(id: challenge.id)
                                    } else {
                                        emblemsVM.addEmblem(id: challenge.id)
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
}
