import SwiftUI
import PhotosUI

struct ProfileView: View {
    @Environment(UserVM.self) private var userVM
    @Environment(\.dismiss) private var dismiss
    @State var challengesVM = ChallengesVM()
    @State private var showEditAbout = false
    @State private var showAddEmblem = false
    
    var body: some View {
        @Bindable var userBVM = userVM
        
        VStack {
            if let user = userVM.activeUser {
                VStack(spacing: 0) {
                    UserAvatarImage(imageData: user.avatarImage)
                        .overlay(alignment: .topTrailing) {
                            PhotosPicker(selection: $userBVM.photoItem, matching: .images) {
                                Image(systemName: "pencil.circle")
                                    .font(.largeTitle)
                                    .tint(.white)
                                    .offset(x: 5)
                            }
                        }
                    
                    Text(user.username)
                        .font(.customTitle2)
                    Text(user.email)
                        .foregroundStyle(.secondary)
                        .font(.customHeadline)
                }
                
                Form {
                    Section {
                        HStack(spacing: 0) {
                            ForEach(Array(challengesVM.emblems.enumerated()), id: \.element.id) { index, emblem in
                                Button {
                                    challengesVM.selectedEmblem = emblem
                                    showAddEmblem.toggle()
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
                                    showAddEmblem.toggle()
                                } label: {
                                    EmblemPlaceholder(showAddEmblem: $showAddEmblem)
                                }
                                if index != max(0, 3 - challengesVM.emblems.count) - 1 {
                                    Spacer()
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    } header: {
                        Text("Personal card")
                            .font(.customTitle3)
                    }
                    .listRowBackground(Color.cardColor)
                    
                    Section {
                        HStack {
                            Text(user.biography ?? "")
                            Spacer()
                            Button {
                                showEditAbout.toggle()
                            } label: {
                                Text(">")
                            }
                            .foregroundStyle(.secondary)
                            .buttonStyle(.plain)
                        }
                    } header: {
                        Text("About")
                            .font(.customTitle3)
                    }
                    .font(.customBody)
                    .listRowBackground(Color.cardColor)

                    Section {
                        Button(role: .destructive) {
                            userVM.logout()
                        } label: {
                            Text("Log Out")
                        }
                    }
                    .font(.customBody)
                    .listRowBackground(Color.cardColor)
                }
            } else {
                Button(role: .destructive) {
                    userVM.logout()
                } label: {
                    Text("Log Out")
                }
            }
        }
        .onAppear {
            challengesVM.getActiveEmblems()
        }
        .onChange(of: userVM.photoItem) { _, _ in
            userVM.editUserAvatar()
        }
        .navigationBarBackButtonHidden()
        .padding(.vertical, 5)
        .scrollContentBackground(.hidden)
        .background(Color.background)
        .overlay(alignment: .topLeading) {
            BackButton {
                dismiss()
            }
            .padding(.horizontal)
        }
        .sheet(isPresented: $showEditAbout) {
            EditAboutView()
        }
        .sheet(isPresented: $showAddEmblem) {
            AddEmblemView(challengesVM: challengesVM)
        }
    }
}

#Preview {
    ProfileView(challengesVM: ChallengesVM(interactor: TestInteractor()))
        .environment(UserVM())
}

