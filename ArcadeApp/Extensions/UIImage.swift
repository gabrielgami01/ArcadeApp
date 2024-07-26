import UIKit

extension UIImage {
    func toBase64(compressionQuality: CGFloat) -> String? {
        // Convert UIImage to Data (using JPEG or PNG format)
        guard let imageData = self.jpegData(compressionQuality: compressionQuality) else {
            return nil
        }
        // Convert Data to Base64 encoded string
        let base64String = imageData.base64EncodedString(options: .lineLength64Characters)
        return base64String
    }
}
