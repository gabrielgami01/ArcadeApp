import Foundation

enum HomePage: String, Identifiable, CaseIterable {
    case friends = "Friends"
    case challenges = "Challenges"
    case rankings = "Rankings"
    case forum = "Forum"
    case profile = "Profile"
    
    var id: Self { self }
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

enum TextFieldType {
    case simple, secured, search
}

enum RatingMode {
    case display, rate
}


