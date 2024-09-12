import Foundation

final class NetworkMock: URLProtocol {
    var urlTest: URL {
        Bundle(for: NetworkMock.self).url(forResource: "gamesPage", withExtension: "json")!
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override func startLoading() {
        if let url = request.url {
            if url.lastPathComponent == "list" {
                guard let data = try? Data(contentsOf: urlTest),
                      let response = HTTPURLResponse(url: url,
                                                     statusCode: 200,
                                                     httpVersion: nil,
                                                     headerFields: ["Content-Type": "application/json; charset=utf-8"]) else { return }
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                client?.urlProtocol(self, didLoad: data)
                
            }
        }
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}
