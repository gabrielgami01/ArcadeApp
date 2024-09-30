import SwiftUI

@Observable
final class ImageVM {
    var image: UIImage?
    
    func getImage(url: URL) {
        let docURL = URL.cachesDirectory.appending(path: url.lastPathComponent)
        if FileManager.default.fileExists(atPath: docURL.path) {
            if let data = try? Data(contentsOf: docURL) {
                image = UIImage(data: data)
            }
        } else {
            Task {
                await fetchImage(from: url)
            }
        }
    }
    
    private func fetchImage(from url: URL) async {
        do {
            let image = try await NetworkImage.shared.fetchImage(from: url)
            self.image = image
        } catch {
            print("Error recuperando la imagen \(url.lastPathComponent).")
        }
    }
}
