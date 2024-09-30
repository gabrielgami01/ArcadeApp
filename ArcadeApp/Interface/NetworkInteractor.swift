import UIKit

protocol NetworkInteractor {
    var session: URLSession { get }
}

extension NetworkInteractor {
    func get<T>(request: URLRequest, builder: (Data) throws -> T) async throws -> T {
        let (data, response) = try await URLSession.shared.getData(for: request)
        
        if response.statusCode == 200 {
            return try builder(data)
        } else {
            throw NetworkError.status(response.statusCode)
        }
    }
    
    func send(request: URLRequest, status: Int) async throws {
        let (_, response) = try await URLSession.shared.getData(for: request)
        if response.statusCode != status {
            throw NetworkError.status(response.statusCode)
        }
    }
}

protocol JSONInteractor: NetworkInteractor {}

extension JSONInteractor {
    func fetchJSON<JSON>(request: URLRequest, type: JSON.Type) async throws -> JSON where JSON: Codable {
        try await get(request: request) { data in
            do {
                return try JSONDecoder.isoDecoder.decode(JSON.self, from: data)
            } catch {
                throw NetworkError.json(error)
            }
        }
    }
}

protocol ImageInteractor: NetworkInteractor {}

extension ImageInteractor  {
    func fetchImage(url: URL) async throws -> UIImage {
        try await get(request: URLRequest.get(url: url)) { data in
            guard let image = UIImage(data: data) else {
                throw NetworkError.dataNotValid
            }
            return image
        }
    }
}
