import SwiftUI
import PhotosUI

struct ProfileView: View {
    @Environment(UserVM.self) private var userVM
    @Environment(ChallengesVM.self) private var challengesVM
    @Environment(SocialVM.self) private var socialVM
    
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
                                ForEach(Array(challengesVM.emblems.enumerated()), id: \.element.id) { index, emblem in
                                    Button {
                                        challengesVM.selectedEmblem = emblem
                                        showAddEmblem = true
                                    } label: {
                                        EmblemCard(emblem: emblem)
                                    }
                                    if index != challengesVM.emblems.count - 1 || challengesVM.emblems.count < 3 {
                                        Spacer()
                                    }
                                }
                                
                                ForEach(0..<max(0, 3 - challengesVM.emblems.count), id: \.self) { index in
                                    Button {
                                        challengesVM.selectedEmblem = nil
                                        showAddEmblem = true
                                    } label: {
                                        AddEmblemCard()
                                    }
                                    if index != max(0, 3 - challengesVM.emblems.count) - 1 {
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
                                Text(user.biography ?? "")
                                
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
                await challengesVM.getUserEmblems()
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
                AddEmblemView()
            }
        }
        
        
    }
}

#Preview {
    ProfileView()
        .environment(UserVM(interactor: TestInteractor()))
        .environment(ChallengesVM(interactor: TestInteractor()))
        .environment(SocialVM(interactor: TestInteractor()))
        .preferredColorScheme(.dark)
}

