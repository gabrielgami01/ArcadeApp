import Foundation
import ACNetwork

protocol LoginInteractorProtocol {
    func createUser(user: CreateUserDTO) async throws
    func loginJWT(user: String, pass: String) async throws
}

struct LoginInteractor: LoginInteractorProtocol, NetworkJSONInteractor {
    static let shared = LoginInteractor()
    
    func getToken() -> String? {
        guard let token = SecKeyStore.shared.readKey(label: "token") else {
            return nil
        }
        return String(data: token, encoding: .utf8)
    }
    
    func createUser(user: CreateUserDTO) async throws {
        var request: URLRequest = .post(url: .createUser, post: user)
        request.setValue(SecManager.shared.appAPIKEY, forHTTPHeaderField: "App-APIKey")
        
        try await post(request: request, status: 201)
    }
    
    func loginJWT(user: String, pass: String) async throws {
        let token = "\(user):\(pass)".data(using: .utf8)?.base64EncodedString()
        let accessToken = try await getJSON(request: .get(url: .loginJWT,token: token,authType: .basic), type: TokenDTO.self)
        SecKeyStore.shared.storeKey(key: Data(accessToken.token.utf8), label: "token")
    }
}
