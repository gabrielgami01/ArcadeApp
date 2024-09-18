import SwiftUI

enum TextFieldType {
    case simple, secured, search
}

enum SignupFields {
    case fullName, email, username, password, repeatPassword
    
    mutating func prev() {
        switch self {
            case .fullName:
                self = .repeatPassword
            case .email:
                self = .fullName
            case .username:
                self = .email
            case .password:
                self = .username
            case .repeatPassword:
                self = .password
        }
    }
    
    mutating func next() {
        switch self {
            case .fullName:
                self = .email
            case .email:
                self = .username
            case .username:
                self = .password
            case .password:
                self = .repeatPassword
            case .repeatPassword:
                self = .fullName
        }
    }
}

enum HomePage: String, Identifiable, CaseIterable {
    case challenges
    case rankings
    case social
    
    var id: Self { self }
    
    var image: String {
        switch self {
            case .challenges:
                return "trophy"
            case .rankings:
                return "rosette"
            case .social:
                return "person.2.fill"
        }
    }
    
    var color: Color {
        switch self {
            case .challenges:
                return .green
            case .rankings:
                return .orange
            case .social:
                return .red
        }
    }
}

enum HomeScrollType: String, Identifiable, CaseIterable {
    case featured, favorites
    
    var id: Self { self }
}

enum GameOptions: String, Identifiable, CaseIterable {
    case about
    case score
    
    var id: Self { self }
}

enum RatingMode {
    case display, rate
}

enum CardAction: String {
    case add
    case update
}

enum ConnectionOptions: String, Identifiable, CaseIterable  {
    case following, followers
    
    var id: Self { self }
}
