import SwiftUI

actor ImageDownloader: ImageService {
    let session: URLSession
    
    static let shared = ImageDownloader()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    private enum ImageStatus {
        case downloading(_ task: Task<UIImage, Error>)
        case downloaded(_ image: UIImage)
    }
    
    private var cache: [URL: ImageStatus] = [:]
    
    func fetchImage(from url: URL) async throws -> UIImage {
        if let imageStatus = cache[url] {
            switch imageStatus {
            case .downloading(let task):
                return try await task.value
            case .downloaded(let image):
                return image
            }
        }
        
        let task = Task {
            try await fetchImage(url: url)
        }
        
        cache[url] = .downloading(task)
        
        do {
            let image = try await task.value
            cache[url] = .downloaded(image)
            try await saveImage(url: url)
            return image
        } catch {
            cache.removeValue(forKey: url)
            throw error
        }
    }
    
    func saveImage(url: URL) async throws {
        guard let imageCached = cache[url] else { return }
        let path = url.lastPathComponent
        let cacheDoc = URL.cachesDirectory.appending(path: path)
        if case .downloaded(let image) = imageCached,
           let resize = await image.byPreparingThumbnail(ofSize: image.size.thumbnailCGSize(width: 300)),
            let data = resize.heicData() {
            try data.write(to: cacheDoc, options: .atomic)
            cache.removeValue(forKey: url)
        }
    }
}
