import SwiftUI

struct ChallengesView: View {
    @Environment(ChallengesVM.self) private var challengesVM
    
    var body: some View {
        @Bindable var challengesBVM = challengesVM
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        
        ScrollView {
            VStack(spacing: 15) {
                CustomTextField(text: $challengesBVM.searchText, label: "Search", type: .search)
                    .scrollTransition(.animated, axis: .vertical) { content, phase in
                        content
                            .opacity(phase.isIdentity ? 1.0 : 0.0)
                    }
                
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(challengesBVM.displayChallenges) { challenge in
                        ChallengeCard(challenge: challenge)
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
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                        .bold()
                        .font(.subheadline)
                }
                .buttonStyle(.plain)
                .padding(.bottom, 5)
            }
        }
        .toolbarBackground(Color.background, for: .navigationBar)
        .navigationBarBackButtonHidden()
        .scrollBounceBehavior(.basedOnSize)
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




