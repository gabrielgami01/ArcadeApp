import Foundation

struct JWTDecoder {
    // Método para verificar si un token JWT ha expirado
    func isTokenExpired(token: String) -> Bool {
        // Separa el token en sus partes
        let segments = token.split(separator: ".")
        guard segments.count == 3 else {
            return true  // Si el token no tiene las tres partes, se considera inválido
        }

        // Decodifica la parte del payload (segunda parte)
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
        
        // Extrae el valor de `exp` (tiempo de expiración)
        if let exp = payload["exp"] as? TimeInterval {
            let expirationDate = Date(timeIntervalSince1970: exp)
            // Compara la fecha de expiración con la fecha actual
            return expirationDate <= Date()
        }
        
        return true // Si no se encuentra `exp`, se considera que el token ha expirado
    }
}
