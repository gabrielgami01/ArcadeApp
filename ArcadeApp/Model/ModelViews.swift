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
}

enum HomeScrollType: String, Identifiable, CaseIterable {
    case featured, favorites
    
    var id: Self { self }
}

enum GameOptions: String, Pickeable {
    case about
    case score
    case session
    
    var id: Self { self }
    var displayName: String  { self.rawValue}
    var displayImage: String? {
        switch self {
            case .about:
                return "info.square.fill"
            case .score:
                return "chart.xyaxis.line"
            case .session:
                return "play.square.fill"
        }
    }
}

enum RatingMode {
    case display, rate
}

enum CardAction: String {
    case add
    case update
}

enum ConnectionOptions: String, Pickeable {
    case following, followers
    
    var id: Self { self }
    var displayName: String { self.rawValue }
    var displayImage: String? { nil }
}


enum SortOption: String, CaseIterable {
    case completed, uncompleted
}

enum BadgeType {
    case display
    case add
    case empty
}
