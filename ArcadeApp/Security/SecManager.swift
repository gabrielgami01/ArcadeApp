import SwiftUI


extension Notification.Name {
    static let logout = Notification.Name("LOGOUT")
}

final class SecManager {
    static let shared = SecManager()
    
    var appAPIKEY = "tokensito"

    var isJWTToken = false
    
    private init() {
        isJWTToken = SecKeyStore.shared.readKey(label: "token") != nil
    }
    
    func logout() {
        SecKeyStore.shared.deleteKey(label: "token")
        isJWTToken.toggle()
    }
}
