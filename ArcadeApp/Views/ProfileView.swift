import SwiftUI

struct ProfileView: View {
    @Environment(UserVM.self) private var userVM
    @Environment(\.dismiss) private var dismiss
    @State private var editAbout = false
    
    var body: some View {
        VStack {
            if let user = userVM.activeUser {
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
                
                Form {
                    Section {
                        HStack {
                            Text(user.biography ?? "")
                            Spacer()
                            Button {
                                editAbout.toggle()
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
        .sheet(isPresented: $editAbout) {
            EditAboutView()
        }
    }
}

#Preview {
    ProfileView()
        .environment(UserVM())
}
