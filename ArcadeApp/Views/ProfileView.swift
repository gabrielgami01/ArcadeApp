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
        Button {
            userVM.logout()
        } label: {
            Text("Logout")
        }
    }
}

#Preview {
    ProfileView()
        .environment(UserVM())
}
