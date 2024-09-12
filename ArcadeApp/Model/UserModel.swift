import Foundation

struct CreateUserDTO: Codable {
    let username: String
    let password: String
    let email: String
    let fullName: String
}

struct LoginDTO: Codable {
    let token: String
    let user: User
}

struct User: Codable, Identifiable, Hashable {
    let id: UUID
    let email: String
    let username: String
    let fullName: String
    let biography: String?
    let avatarImage: Data?
}

struct UserFollows: Codable, Identifiable, Hashable {
    let id: UUID
    let user: User
    let createdAt: Date
}

struct UpdateUserAboutDTO: Codable {
    let about: String
}

struct UpdateUserAvatarDTO: Codable {
    let image: Data
}

struct UserDTO: Codable {
    let id: UUID
}
