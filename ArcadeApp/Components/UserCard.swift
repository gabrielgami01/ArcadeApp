import SwiftUI

struct UserCard: View {
    @State var emblemsVM = EmblemsVM()
    let user: User
    
    var body: some View {
        VStack(spacing: 30) {
            HStack(spacing: 10) {
                UserAvatarImage(imageData: user.avatarImage, height: 75, width: 75)
                
                VStack(alignment: .leading) {
                    Text(user.username)
                        .font(.customTitle3)
                    
                    if let about = user.biography {
                        Text(about)
                            .font(.customFootnote)
                    }
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Text("Add Friend")
                }
                .buttonStyle(.borderedProminent)
                
            }
            
            HStack(spacing: 0) {
                ForEach(Array(emblemsVM.emblems.enumerated()), id: \.element.id) { index, emblem in
                    EmblemCard(emblem: emblem)
                    if index != emblemsVM.emblems.count - 1 || emblemsVM.emblems.count < 3 {
                        Spacer()
                    }
                }
                
                ForEach(0..<max(0, 3 - emblemsVM.emblems.count), id: \.self) { index in
                    EmblemCard(emblem: nil)
                    if index != max(0, 3 - emblemsVM.emblems.count) - 1 {
                        Spacer()
                    }
                }
            }
        }
        .task {
            await emblemsVM.getUserEmblems(id: user.id)
        }
        .padding()
        .background(.card, in: .rect(cornerRadius: 10))
    }
}

#Preview {
    UserCard(emblemsVM: EmblemsVM(interactor: TestInteractor()), user: .test)
        .preferredColorScheme(.dark)
}
