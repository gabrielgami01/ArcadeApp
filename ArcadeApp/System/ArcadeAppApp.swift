//
//  ArcadeAppApp.swift
//  ArcadeApp
//
//  Created by Gabriel Garcia Millan on 21/6/24.
//

import SwiftUI

@main
struct ArcadeAppApp: App {
    @State private var loginVM = LoginVM()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(loginVM)
        }
    }
}
