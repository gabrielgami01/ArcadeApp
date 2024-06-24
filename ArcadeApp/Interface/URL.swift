import Foundation

let desa = URL(string: "http://localhost:8080/api")!

let api = desa

extension URL {
    static let createUser = api.appending(path: "users").appending(path: "create")
    static let loginJWT = api.appending(path: "users").appending(path: "loginJWT")
}
