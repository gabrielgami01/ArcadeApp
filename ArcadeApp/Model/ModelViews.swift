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
    case challenges = "Challenges"
    case rankings = "Rankings"
    case profile = "Profile"
    
    var id: Self { self }
    
    var image: String {
        switch self {
            case .challenges:
                return "trophy"
            case .rankings:
                return "rosette"
            case .profile:
                return "person.crop.circle"
        }
    }
    
    var color: Color {
        switch self {
            case .challenges:
                return .green
            case .rankings:
                return .orange
            case .profile:
                return .red
        }
    }
}

enum HomeScrollType: String, Identifiable, CaseIterable {
    case featured, favorites
    
    var id: Self { self }
}

enum PickerOptions: String, Identifiable, CaseIterable {
    case about = "About"
    case score = "My scores"
    
    var id: Self { self }
}

enum RatingMode {
    case display, rate
}

enum CardAction: String {
    case add
    case update
}
