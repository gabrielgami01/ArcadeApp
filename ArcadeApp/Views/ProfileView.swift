import SwiftUI
import PhotosUI

struct ProfileView: View {
    @Environment(UserVM.self) private var userVM
    @Environment(SocialVM.self) private var socialVM
    @State var emblemsVM = EmblemsVM()
    
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
                            NavigationLink(value: ProfilePage.following) {
                                HStack(spacing: 5) {
                                    Text("\(socialVM.following.count)")
                                    Text("Following")
                                        .foregroundStyle(.secondary)
                                }
                            }
                            
                            NavigationLink(value: ProfilePage.followers) {
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
                                ForEach(Array(emblemsVM.emblems.enumerated()), id: \.element.id) { index, emblem in
                                    Button {
                                        emblemsVM.selectedEmblem = emblem
                                        showAddEmblem = true
                                    } label: {
                                        EmblemCard(emblem: emblem)
                                    }
                                    if index != emblemsVM.emblems.count - 1 || emblemsVM.emblems.count < 3 {
                                        Spacer()
                                    }
                                }
                                
                                ForEach(0..<max(0, 3 - emblemsVM.emblems.count), id: \.self) { index in
                                    Button {
                                        emblemsVM.selectedEmblem = nil
                                        showAddEmblem = true
                                    } label: {
                                        AddEmblemCard()
                                    }
                                    if index != max(0, 3 - emblemsVM.emblems.count) - 1 {
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
                await emblemsVM.getUserEmblems()
            }
            .navigationBarBackButtonHidden()
            .scrollContentBackground(.hidden)
            .scrollBounceBehavior(.basedOnSize)
            .scrollIndicators(.hidden)
            .background(Color.background)
            .navigationDestination(for: ProfilePage.self) { page in
                switch page {
                    case .following:
                        FollowsView(selectedPage: page)
                    case .followers:
                        FollowsView(selectedPage: page)
                }
            }
            .sheet(isPresented: $showEditAbout) {
                EditAboutView()
            }
            .sheet(isPresented: $showAddEmblem) {
                AddEmblemView(emblemsVM: emblemsVM)
            }
        }
        
        
    }
}

#Preview {
    ProfileView()
        .environment(UserVM(interactor: TestInteractor()))
        .environment(SocialVM(interactor: TestInteractor()))
        .preferredColorScheme(.dark)
}

