import Foundation

protocol Master {
    var id: UUID { get }
    var name: String { get }
}

struct Genre: Codable, Identifiable, Hashable, Master {
    let id: UUID
    let name: String
}

struct Console: Codable, Identifiable, Hashable, Master {
    let id: UUID
    let name: String
}


