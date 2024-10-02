import Foundation

struct JWTDecoder {
    func isTokenExpired(token: String) -> Bool {
        let segments = token.split(separator: ".")
        guard segments.count == 3 else {
            return true
        }
        
        let base64String = String(segments[1])
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        var base64Length = base64String.count
        while base64Length % 4 != 0 {
            base64Length += 1
        }
        
        let paddedBase64String = base64String.padding(toLength: base64Length, withPad: "=", startingAt: 0)
        
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
