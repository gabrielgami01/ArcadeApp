import SwiftUI

struct AsyncTypeWriterIterator: AsyncIteratorProtocol {
    typealias Element = String
    
    let message: String
    var index: String.Index
    
    init(message: String) {
        self.message = message
        self.index = message.startIndex
    }
    
    mutating func next() async throws -> String? {
        guard index < message.endIndex else { return nil }
        try await Task.sleep(for: .seconds(Double.random(in: 0.05...0.15)))
        defer { index = message.index(after: index) }
        return String(message[message.startIndex ... index])
    }
}

struct AsyncTypeWriter: AsyncSequence {
    typealias Element = String
    typealias AsyncIterator = AsyncTypeWriterIterator
    
    let message: String
    
    func makeAsyncIterator() -> AsyncTypeWriterIterator {
        AsyncTypeWriterIterator(message: message)
    }
}
