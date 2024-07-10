//
//  ProfileView.swift
//  ArcadeApp
//
//  Created by Gabriel Garcia Millan on 30/6/24.
//

import SwiftUI

struct ProfileView: View {
    @Environment(UserVM.self) private var userVM
    
    var body: some View {
        ScrollView {
            Button {
                userVM.logout()
            } label: {
                Text("Logout")
            }
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .background(Color("backgroundColor"))
    }
}

#Preview {
    ProfileView()
        .environment(UserVM())
        .preferredColorScheme(.dark)
}
