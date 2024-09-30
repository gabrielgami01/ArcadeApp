import Foundation

enum AuthType {
    case basic
    case token
}

enum HTTPMethod: String {
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

extension URLRequest {
    static func get(url: URL, token: String? = nil, authType: AuthType = .token) -> URLRequest {
        var request = URLRequest(url: url)
        request.timeoutInterval = 60
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        switch authType {
            case .basic:
                if let token {
                    request.setValue("Basic \(token)", forHTTPHeaderField: "Authorization")
                }
            case .token:
                if let token {
                    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                }
        }
        
        return request
    }
    
    static func send<T>(url: URL, data: T, method: HTTPMethod, token: String? = nil, authType: AuthType = .token) -> URLRequest where T: Codable {
        var request = URLRequest(url: url)
        request.timeoutInterval = 60
        request.httpMethod = method.rawValue
        request.httpBody = try? JSONEncoder.isoEncoder.encode(data)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        switch authType {
            case .basic:
                if let token {
                    request.setValue("Basic \(token)", forHTTPHeaderField: "Authorization")
                }
            case .token:
                if let token {
                    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                }
        }
        
        return request
    }
}
