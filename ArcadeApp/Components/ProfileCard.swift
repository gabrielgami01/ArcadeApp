import SwiftUI
import PhotosUI

struct ProfileCard: View {
    @Environment(UserVM.self) private var userVM
    @Environment(SocialVM.self) private var socialVM
    
    let user: User
    
    var body: some View {
        @Bindable var userBVM = userVM
        
        VStack {
            UserAvatarImage(imageData: user.avatarImage)
                .overlay(alignment: .topTrailing) {
                    PhotosPicker(selection: $userBVM.photoItem, matching: .images) {
                        Image(systemName: "pencil.circle")
                            .font(.largeTitle)
                            .tint(.white)
                            .offset(x: 25)
                    }
                }
            
            Text(user.username)
                .font(.customTitle)
            
            Text(user.email)
                .foregroundStyle(.secondary)
                .font(.customHeadline)
            
            HStack {
                NavigationLink(value: ConnectionOptions.following) {
                    HStack(spacing: 5) {
                        Text("\(socialVM.following.count)")
                        Text("Following")
                            .foregroundStyle(.secondary)
                    }
                }
                
                NavigationLink(value: ConnectionOptions.followers) {
                    HStack(spacing: 5) {
                        Text("\(socialVM.followers.count)")
                        Text("Followers")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .buttonStyle(.plain)
            .font(.customBody)
            .padding(.top, 5)
        }
    }
}
#Preview {
    NavigationStack {
        ProfileCard(user: .test)
            .environment(UserVM(repository: TestRepository()))
            .environment(SocialVM(repository: TestRepository()))
            .preferredColorScheme(.dark)
    }
}
