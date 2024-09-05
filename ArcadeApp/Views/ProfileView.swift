import SwiftUI
import PhotosUI

struct ProfileView: View {
    @Environment(UserVM.self) private var userVM
    @State var emblemsVM = EmblemsVM()
    @State private var showEditAbout = false
    @State private var showAddEmblem = false
    
    
    var body: some View {
        @Bindable var userBVM = userVM
        
        VStack {
            if let user = userVM.activeUser {
                VStack {
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
                            ForEach(Array(emblemsVM.emblems.enumerated()), id: \.element.id) { index, emblem in
                                Button {
                                    emblemsVM.selectedEmblem = emblem
                                    showAddEmblem.toggle()
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
                                    showAddEmblem.toggle()
                                } label: {
                                    AddEmblemCard()
                                }
                                if index != max(0, 3 - emblemsVM.emblems.count) - 1 {
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
            }
        }
        .task {
            await emblemsVM.getUserEmblems()
        }
        .onChange(of: userVM.photoItem) { _, _ in
            userVM.editUserAvatar()
        }
        .sheet(isPresented: $showEditAbout) {
            EditAboutView()
        }
        .sheet(isPresented: $showAddEmblem) {
            AddEmblemView(emblemsVM: emblemsVM)
        }
        .navigationBarBackButtonHidden()
        .scrollContentBackground(.hidden)
        .background(Color.background)
        
        
    }
}

#Preview {
    ProfileView()
        .environment(UserVM(interactor: TestInteractor()))
        .preferredColorScheme(.dark)
}

