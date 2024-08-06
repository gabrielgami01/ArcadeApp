import SwiftUI

struct ChallengesView: View {
    @Environment(\.dismiss) private var dismiss
    @State var challengesVM = ChallengesVM()
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack(alignment: .firstTextBaseline, spacing: 20) {
                    Button {
                       dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                    
                    Text("Challenges")
                        .font(.customLargeTitle)
                }
                .padding(.horizontal)
                
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 10) {
                        ForEach(ChallengeType.allCases) { type in
                            if let namespace{
                                Button {
                                    withAnimation(.interactiveSpring(
                                        response: 0.5, dampingFraction: 0.7, blendDuration: 0.7)
                                    ) {
                                        challengesVM.activeType = type
                                    }
                                } label: {
                                    Text(type.rawValue.capitalized)
                                        .font(.customCaption2)
                                }
                                .buttonStyle(ConsoleButtonStyle(isActive: challengesVM.activeType == type, namespace: namespace))
                            }
                        }
                    }
                    .frame(height: 30)
                    .safeAreaPadding(.horizontal)
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
            
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(challengesVM.challenges) { challenge in
                        ChallengeCard(challenge: challenge)
                    }
                }
                .padding(.horizontal)
            }
        }
        .animation(.easeInOut, value: challengesVM.challenges)
        .onChange(of: challengesVM.activeType) { oldValue, newValue in
            challengesVM.getChallenges(type: newValue)
        }
        .navigationBarBackButtonHidden()
        .scrollIndicators(.hidden)
        
    }
}

#Preview {
    ChallengesView(challengesVM: ChallengesVM(interactor: TestInteractor()))
        .namespace(Namespace().wrappedValue)
}




