import Foundation

struct JWTDecoder {
    
    private func base64Padding(jwt: String) -> String {
        var encoded = jwt
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        let count = encoded.count % 4
        for _ in 0 ..< count {
            encoded += "="
        }
        return encoded
    }
    
    func isTokenExpired(token: String) -> Bool {
        let segments = token.split(separator: ".")
        guard segments.count == 3 else {
            return true
        }
        
        let paddedBase64String = base64Padding(jwt: token)
        
        guard let payloadData = Data(base64Encoded: paddedBase64String),
              let json = try? JSONSerialization.jsonObject(with: payloadData, options: []),
              let payload = json as? [String: Any] else {
            return true
        }
        
        
        if let exp = payload["exp"] as? TimeInterval {
            let expirationDate = Date(timeIntervalSince1970: exp)
            return expirationDate <= Date()
        }
        
        return true 
    }
}
