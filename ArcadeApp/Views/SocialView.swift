import SwiftUI

struct SocialView: View {
    @Environment(SocialVM.self) private var socialVM
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                ForEach(socialVM.followers) { userConnection in
                    SocialCell(userConnection: userConnection)
                }
            }
        }
        .headerToolbar(title: "Social") { dismiss() }
        .padding(.horizontal)
        .scrollBounceBehavior(.basedOnSize)
        .scrollIndicators(.hidden)
        .background(Color.background)
    }
}

#Preview {
    NavigationStack {
        SocialView()
            .environment(UserVM(interactor: TestInteractor()))
            .environment(SocialVM(interactor: TestInteractor()))
            .preferredColorScheme(.dark)
    }
}

