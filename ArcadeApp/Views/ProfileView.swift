import SwiftUI
import PhotosUI

struct ProfileView: View {
    @Environment(UserVM.self) private var userVM
    @Environment(SocialVM.self) private var socialVM
    @Environment(BadgesVM.self) private var badgesVM
    
    @State private var showEditAbout = false
    @State private var showAddEmblem = false
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        @Bindable var userBVM = userVM
        
        NavigationStack {
            VStack {
                if let user = userVM.activeUser {
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
                    
                    Form {
                        Section {
                            HStack(spacing: 0) {
                                ForEach(Array(badgesVM.featuredBadges.enumerated()), id: \.element.id) { index, badge in
                                    Button {
                                        badgesVM.selectedBadge = badge
                                        showAddEmblem.toggle()
                                    } label: {
                                        BadgeCard(badge: badge)
                                    }
                                    
                                    if index != badgesVM.featuredBadges.count - 1 || badgesVM.featuredBadges.count < 3 {
                                        Spacer()
                                    }
                                }
                                
                                ForEach(0..<max(0, 3 - badgesVM.featuredBadges.count), id: \.self) { index in
                                    Button {
                                        badgesVM.selectedOrder = index + badgesVM.featuredBadges.count
                                        showAddEmblem.toggle()
                                    } label: {
                                        AddBadgeCard()
                                    }
                                    
                                    if index != max(0, 3 - badgesVM.featuredBadges.count) - 1 {
                                        Spacer()
                                    }
                                }
                            }
                        } header: {
                            Text("Personal card")
                                .font(.customTitle3)
                        }
                        .buttonStyle(.plain)
                        .listRowBackground(Color.card)
                        
                        Section {
                            HStack {
                                Text(user.about ?? "")
                                
                                Spacer()
                                
                                Button {
                                    showEditAbout = true
                                } label: {
                                    Text(">")
                                }
                                .foregroundStyle(.secondary)
                                
                            }
                        } header: {
                            Text("About")
                                .font(.customTitle3)
                        }
                        .font(.customBody)
                        .listRowBackground(Color.card)
                        
                        Section {
                            Button(role: .destructive) {
                                userVM.logout()
                            } label: {
                                Text("Log Out")
                            }
                        }
                        .font(.customBody)
                        .listRowBackground(Color.card)

                    }
                }
            }
            .task {
                await badgesVM.getBadges()
            }
            .navigationBarBackButtonHidden()
            .scrollContentBackground(.hidden)
            .scrollBounceBehavior(.basedOnSize)
            .scrollIndicators(.hidden)
            .background(Color.background)
            .navigationDestination(for: ConnectionOptions.self) { page in
                switch page {
                    case .following:
                        ConnectionsView(selectedPage: page)
                    case .followers:
                        ConnectionsView(selectedPage: page)
                }
            }
            .sheet(isPresented: $showEditAbout) {
                EditAboutView()
            }
            .sheet(isPresented: $showAddEmblem) {
                AddBadgeView()
            }
        }  
    }
}

#Preview {
    ProfileView()
        .environment(UserVM(repository: TestRepository()))
        .environment(SocialVM(repository: TestRepository()))
        .environment(BadgesVM(repository: TestRepository()))
        .preferredColorScheme(.dark)
}


struct BadgeCard: View {
    let badge: Badge
    
    var body: some View {
        VStack {
            Text(badge.name)
                .font(.customFootnote)
                .foregroundStyle(.secondary)
                .lineLimit(2, reservesSpace: true)
                .multilineTextAlignment(.center)
                .frame(width: 100)
            
            Image(systemName: "trophy.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 75)
        }
    }
}

struct AddBadgeCard: View {
    var body: some View {
        VStack {
            Text("Add badge")
                .font(.customFootnote)
                .foregroundStyle(.secondary)
                .lineLimit(2, reservesSpace: true)
                .multilineTextAlignment(.center)
            
            Image(systemName: "plus.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 75)
        }
    }
}
