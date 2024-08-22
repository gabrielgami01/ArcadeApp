import SwiftUI



struct ProfileView: View {
    @Environment(UserVM.self) private var userVM
    @Environment(\.dismiss) private var dismiss
    @State var challengesVM = ChallengesVM()
    @State private var showEditAbout = false
    @State private var showAddEmblem = false
    
    var body: some View {
        VStack {
            if let user = userVM.activeUser {
                VStack(spacing: 0) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                        .foregroundStyle(.secondary)
                        .overlay(alignment: .topTrailing) {
                            Button {
                                
                            } label: {
                                Image(systemName: "pencil.circle")
                                    .font(.largeTitle)
                                    .tint(.white)
                                    .offset(x: 10, y: -10)
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
                            // Para los emblemas existentes
                            ForEach(Array(challengesVM.emblems.enumerated()), id: \.element.id) { index, emblem in
                                Button {
                                    challengesVM.selectedEmblem = emblem
                                    showAddEmblem.toggle()
                                } label: {
                                    EmblemCard(emblem: emblem)
                                }
                                // Añadir Spacer si no es el último elemento
                                if index != challengesVM.emblems.count - 1 || challengesVM.emblems.count < 3 {
                                    Spacer()
                                }
                            }
                            
                            // Para los placeholders
                            ForEach(0..<max(0, 3 - challengesVM.emblems.count), id: \.self) { index in
                                Button {
                                    challengesVM.selectedEmblem = nil
                                    showAddEmblem.toggle()
                                } label: {
                                    EmblemPlaceholder(showAddEmblem: $showAddEmblem)
                                }
                                // Añadir Spacer si no es el último elemento
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
        .environment(UserVM(interactor: TestInteractor()))
}

struct EmblemPlaceholder: View {
    @Binding var showAddEmblem: Bool
    
    var body: some View {
        VStack {
            Text("Add new emblem")
                .font(.customFootnote)
                .foregroundStyle(.secondary)
                .lineLimit(2, reservesSpace: true)
                .multilineTextAlignment(.center)
            
            Image(systemName: "plus.circle")
                .resizable()
                .symbolVariant(.fill)
                .scaledToFit()
                .frame(height: 75)
        }
    }
}

struct EmblemCard: View {
    let emblem: Emblem
    
    var body: some View {
        VStack {
            Text(emblem.name)
                .font(.customFootnote)
                .foregroundStyle(.secondary)
                .lineLimit(2, reservesSpace: true)
                .multilineTextAlignment(.center)
            
            Image(systemName: "trophy")
                .resizable()
                .symbolVariant(.fill)
                .scaledToFit()
                .frame(height: 75)
        }
    }
}
