//
//  CustomLoginButton.swift
//  ArcadeApp
//
//  Created by Gabriel Garcia Millan on 21/6/24.
//

import SwiftUI

struct CustomLoginButton: View {
    let label: String
    let actions: () -> Void
    
    var body: some View {
        Button {
            actions()
        } label: {
            Text(label)
                .font(.headline)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    CustomLoginButton(label: "Login", actions: {})
        .safeAreaPadding()
}
