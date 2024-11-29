import SwiftUI

enum Tabs {
    case home, search, profile
}

struct TabItem: Identifiable {
    let id = UUID()
    let name: String
    let symbol: String
    let tab: Tabs
}

enum HomePage: String, Identifiable, CaseIterable {
    case challenges, rankings
    
    var id: Self { self }
    
    var image: String {
        switch self {
            case .challenges:
                return "trophy"
            case .rankings:
                return "rosette"
        }
    }
}

enum HomeScrollType: String, Identifiable, CaseIterable {
    case featured, favorites
    
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

enum GameOptions: String, Pickeable {
    case about, score, session
    
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

enum ConnectionOptions: String, Pickeable {
    case following, followers
    
    var id: Self { self }
    var displayName: String { self.rawValue }
    var displayImage: String? { nil }
}

enum TextFieldType {
    case simple, secured, search
}

enum SortOption: String, CaseIterable {
    case completed, uncompleted
}

enum BadgeType {
    case display, add, empty
}

enum RatingMode {
    case display, rate
}

