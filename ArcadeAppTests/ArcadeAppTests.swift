import XCTest
@testable import ArcadeApp

final class ArcadeAppTests: XCTestCase {
    var network: Network!

    override func setUpWithError() throws {
        let config = URLSessionConfiguration.default
        config.protocolClasses = [NetworkMock.self]
        let session = URLSession(configuration: config)
        network = Network(session: session)
    }

    override func tearDownWithError() throws {
        network = nil
    }

    func testLoadGames() async throws {
        let games = try await network.getAllGames(page: 1)
        XCTAssertEqual(games.count, 20)
    }
    
}
