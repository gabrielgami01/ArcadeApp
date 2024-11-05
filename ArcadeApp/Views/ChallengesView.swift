import SwiftUI

struct ChallengesView: View {
    @State var challengesVM = ChallengesVM()
    
    @FocusState private var focus: Bool
    
    var body: some View {
        @Bindable var challengesBVM = challengesVM
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        
        ScrollView {
            VStack(spacing: 15) {
                CustomTextField(text: $challengesBVM.searchText, label: "Search", type: .search)
                    .focused($focus)
                    .scrollTransition(.animated, axis: .vertical) { content, phase in
                        content
                            .opacity(phase.isIdentity ? 1.0 : 0.0)
                    }
                
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(challengesBVM.displayChallenges) { challenge in
                        ChallengeCard(challenge: challenge)
                            .onTapGesture {
                                focus = false
                            }
                    }
                }
            }
            .padding(.horizontal)
        }
        .task {
            await challengesVM.getChallenges()
        }
        .refreshable {
            Task {
                await challengesVM.getChallenges()
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack(alignment: .firstTextBaseline, spacing: 20) {
                    BackButton()
                    
                    Text("Challenges")
                        .font(.customLargeTitle)
                }
                .padding(.bottom, 5)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    challengesVM.sortOption = challengesVM.sortOption == .completed ? .uncompleted : .completed
                    focus = false
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.customFootnote)
                        .bold()
                        .rotation3DEffect(.degrees(challengesVM.sortOption == .completed ? 180 : 0), axis: (x: 1, y: 0, z: 0))
                }
                .buttonStyle(.plain)
                .padding(.bottom, 5)
                
            }
        }
        .toolbarBackground(Color.background, for: .navigationBar)
        .navigationBarBackButtonHidden()
        .scrollDismissesKeyboard(.immediately)
        .scrollBounceBehavior(.basedOnSize)
        .background(Color.background)
    }
}

#Preview {
    NavigationStack {
        ChallengesView(challengesVM: ChallengesVM(repository: TestRepository()))
            .preferredColorScheme(.dark)
            .namespace(Namespace().wrappedValue)
    }
}




