import SwiftUI


extension Notification.Name {
    static let logout = Notification.Name("LOGOUT")
}

final class SecManager {
    static let shared = SecManager()
    
    private let AK: [UInt8] = [ 0x0C+0x55, 0x34+0x3D, 0x80-0x10, 0x1B+0x19, 0x61-0x18, 0x49+0x22, 0x4F+0x23, 0x9F-0x4D, 0x48+0x11, 0x96-0x2B, 0x4D-0x04, 0x39-0x07, 0x61-0x0F, 0xC2-0x54, 0x2B+0x17, 0x4E-0x16, 0x95-0x42, 0x62+0x09, 0x76-0x2D, 0x9E-0x36, 0xE8-0x73, 0xA1-0x36, 0x64-0x31, 0xB1-0x43, 0x8B-0x37, 0x16+0x1A, 0x34+0x45, 0x7C-0x2B, 0x02+0x4A, 0x46-0x17, 0x75-0x1B, 0x2A+0x0D, 0x4D+0x29, 0x4F-0x18, 0x99-0x45, 0x1D+0x2B, 0x08+0x2A, 0x74-0x0C, 0x59-0x18, 0x55+0x23, 0x19+0x12, 0x58-0x28, 0x15+0x2C, 0x53-0x16]
    
    var appAPIKEY: String {
        String(data: Data(AK), encoding: .utf8) ?? ""
    }

    var isJWTToken = false
    
    private init() {
        isJWTToken = SecKeyStore.shared.readKey(label: "token") != nil
    }
    
    func logout() {
        SecKeyStore.shared.deleteKey(label: "token")
        isJWTToken.toggle()
    }
}
