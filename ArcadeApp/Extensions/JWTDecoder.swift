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
        if count > 0 {
            for _ in 0 ..< (4 - count) {
                encoded += "="
            }
        }
        return encoded
    }

    func isTokenExpired(token: String) -> Bool {
        let jwtParts = token.components(separatedBy: ".")
        
        guard jwtParts.count == 3 else {
            return true
        }

        let bodyb64 = base64Padding(jwt: jwtParts[1])
        
        guard let bodyData = Data(base64Encoded: bodyb64) else {
            return true
        }

        let decoder = JSONDecoder()
        guard let payload = try? decoder.decode(JWTPayload.self, from: bodyData),
              let exp = payload.exp else {
            return true
        }

        let currentTime = Date().timeIntervalSince1970

        return currentTime >= exp
    }

    
}

