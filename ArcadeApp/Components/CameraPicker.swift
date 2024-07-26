import SwiftUI

struct CameraPicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    
    @Binding var photo: UIImage?
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        @Binding var photo: UIImage?
        
        init(photo: Binding<UIImage?>) {
            self._photo = photo
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true)
            photo = info[.editedImage] as? UIImage
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(photo: $photo)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        picker.allowsEditing = true
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
