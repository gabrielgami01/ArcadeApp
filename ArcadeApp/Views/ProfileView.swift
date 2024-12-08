import SwiftUI
import PhotosUI

struct ProfileView: View {
    @Environment(UserVM.self) private var userVM
    @Environment(SocialVM.self) private var socialVM
    @State var badgesVM = BadgesVM()

    @State private var showEditAbout = false
    @State private var showAddBadge = false

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        @Bindable var userBVM = userVM
        NavigationStack {
            ScrollView {
                if let user = userVM.activeUser {
                    VStack(spacing: 20) {
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
                        
                        VStack(alignment: .leading) {
                            Text("PERSONAL CARD")
                                .font(.customTitle3)
                                .foregroundStyle(.secondary)
                                .padding(.leading)
                            
                            BadgesCard(badges: badgesVM.featuredBadges) { badge in
                                Button {
                                    badgesVM.selectedBadge = badge
                                    showAddBadge.toggle()
                                } label: {
                                    BadgeCard(type: .display, badge: badge)
                                }
                            } emptyBadge: { index in
                                Button {
                                    badgesVM.selectedOrder = index + badgesVM.featuredBadges.count
                                    showAddBadge.toggle()
                                } label: {
                                    BadgeCard(type: .add)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("ABOUT")
                                .font(.customTitle3)
                                .foregroundStyle(.secondary)
                                .padding(.leading)
                            
                            HStack {
                                Text(user.about ?? "")

                                Spacer()

                                Button {
                                    showEditAbout = true
                                } label: {
                                    Text(">")
                                }
                                .buttonStyle(.plain)
                            }
                            .font(.customBody)
                            .foregroundStyle(.secondary)
                            .padding()
                            .background(Color.card, in: RoundedRectangle(cornerRadius: 10))
                        }
                        
                        Button(role: .destructive) {
                            userVM.logout()
                        } label: {
                            Text("Log Out")
                        
                        }
                        .font(.customBody)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.card, in: RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(.horizontal)
                    
                }
            }
            .task {
                await badgesVM.getBadges()
            }
            .refreshable {
                Task {
                    await badgesVM.getBadges()
                }
            }
            .navigationDestination(for: ConnectionOptions.self) { page in
                switch page {
                    case .following:
                        ConnectionsView(selectedPage: page)
                    case .followers:
                        ConnectionsView(selectedPage: page)
                }
            }
            .tabBarInset()
            .sheet(isPresented: $showEditAbout) {
                EditAboutView()
            }
            .sheet(isPresented: $showAddBadge) {
                AddBadgeView(badgesVM: badgesVM)
            }
           .scrollIndicators(.hidden)
           .background(Color.background)
           .errorAlert(show: $badgesVM.showError)
        }
    }
}

#Preview {
    ProfileView(badgesVM: BadgesVM(repository: TestRepository()))
        .environment(UserVM(repository: TestRepository()))
        .environment(SocialVM(repository: TestRepository()))
        .preferredColorScheme(.dark)
}
