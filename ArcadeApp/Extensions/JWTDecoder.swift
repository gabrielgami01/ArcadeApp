import Foundation

struct JWTPayload: Codable {
    let exp: TimeInterval?
}

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
        
        let paddedBase64String = base64Padding(jwt: String(segments[1]))
        
        guard let payloadData = Data(base64Encoded: paddedBase64String) else {
            return true
        }
        
        let decoder = JSONDecoder()
        if let payload = try? decoder.decode(JWTPayload.self, from: payloadData), let exp = payload.exp {
                let expirationDate = Date(timeIntervalSince1970: exp)
                return expirationDate <= Date()
        }
                
        return true
    }
}
