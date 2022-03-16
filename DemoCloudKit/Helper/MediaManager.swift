//
//  MediaManager.swift
//  DemoCloudKit
//
//  Created by Mac-0004 on 24/02/22.
//

import Foundation
import UIKit

var topMostViewController: UIViewController? {
    return UIApplication.shared.topMostVC()
}

let CMediaManagerShared = MediaManager.shared

final class MediaManager: NSObject {
    
    /// Shared(Singleton) object of MediaManager class.
    static let shared: MediaManager = MediaManager()
    
    private(set) lazy var imagePickerController: UIImagePickerController = {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        return imagePickerController
    }()
    
    private(set) var completion: ((_ image: UIImage?, _ info: [UIImagePickerController.InfoKey : Any]?) -> ())?
}

extension MediaManager {
    
    var allowsEditing: Bool {
        get {
            return imagePickerController.allowsEditing
        } set {
            imagePickerController.allowsEditing = newValue
        }
    }
    
    enum MediaSourceType: Equatable {
        
        case photoLibrary(String)
        case camera(String)
        case savedPhotosAlbum(String)
        
        fileprivate var strValue: String {
            
            switch self {
                
            case .photoLibrary(let strPhotoLibrary):
                return strPhotoLibrary
                
            case .camera(let strCamera):
                return strCamera
                
            case .savedPhotosAlbum(let strSavedPhotosAlbum):
                return strSavedPhotosAlbum
            }
        }
        
        fileprivate func takeAppropriateAction(mediaManager: MediaManager) {
            
            switch self {
                
            case .camera:
                mediaManager.takeAPhoto()
                
            case .photoLibrary:
                mediaManager.chooseFromPhotoLibrary()
                
            case .savedPhotosAlbum:
                mediaManager.chooseFromSavedPhotosAlbum()
            }
        }
    }
}

extension MediaManager {
    
    func presentImagePickerController(isEditing: Bool = true, title: String? = nil, message: String? = nil, mediaType: [MediaSourceType], commpletion: ((_ image: UIImage?, _ info: [UIImagePickerController.InfoKey : Any]?) -> ())?) {
        
        self.allowsEditing = isEditing
        
        let mediaSourceTypes = mediaType.removeDuplicates()
        var actions : [AAction] = []
        let _ = mediaSourceTypes.compactMap({actions.append(AAction.Custom(title: $0.strValue))})
        guard !actions.isEmpty else {
            return
        }
        actions.append(.Cancel)
        
        topMostViewController?.alertView(title: title, message: message, style: .actionSheet, actions: actions, handler: { [weak self] (action) in
            guard let self = self else { return }
            if action == AAction.Cancel { return }
            guard let index = actions.indexes(of: action).first else { return }
            let medisSource = mediaType[index]
            medisSource.takeAppropriateAction(mediaManager: self)
        })
        self.completion = commpletion
    }
    
    /// A method used to select an image from camera when you want to use seperately.
    func takePhotoFromCamera(completion: ((_ image: UIImage?, _ info: [UIImagePickerController.InfoKey : Any]?) -> ())?) {
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            let msg = "Your device doesn't support camera."
            topMostViewController?.alertView(message:msg,actions: [.Ok])
            return
        }
        
        imagePickerController.sourceType = .camera
        imagePickerController.allowsEditing = allowsEditing
        topMostViewController?.present(imagePickerController, animated: true, completion: nil)
        self.completion = completion
    }
    
    /// A method used to select an image from photoLibrary when you want to use seperately.
    func chooseFromGallery(completion: ((_ image: UIImage?, _ info: [UIImagePickerController.InfoKey : Any]?) -> ())?) {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            let msg = "Your device doesn't support photo library."
            topMostViewController?.alertView(message:msg,actions: [.Ok])
            return
        }
        
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = allowsEditing
        DispatchQueue.main.async {
            topMostViewController?.present(self.imagePickerController, animated: true, completion: nil)
                }
            
            self.completion = completion
        
    }
    
    /// A private method used to select an image from camera.
    private func takeAPhoto() {
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else{
            let msg = "Your device doesn't support camera."
            topMostViewController?.alertView(message:msg,actions: [.Ok])
            return
        }
        
        imagePickerController.sourceType = .camera
        imagePickerController.allowsEditing = allowsEditing
        topMostViewController?.present(imagePickerController, animated: true, completion: nil)
    }
    
    /// A private method used to select an image from photoLibrary.
    private func chooseFromPhotoLibrary() {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            let msg = "Your device doesn't support photo library."
            topMostViewController?.alertView(message:msg,actions: [.Ok])
            return
        }
        
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = allowsEditing
        topMostViewController?.present(imagePickerController, animated: true, completion: nil)
    }
    
    /// A private method used to select an image from savedPhotosAlbum.
    private func chooseFromSavedPhotosAlbum() {
        
        guard UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) else {
            let msg = "Your device doesn't support photo library."
            topMostViewController?.alertView(message:msg,actions: [.Ok])
            return
        }
        
        imagePickerController.sourceType = .savedPhotosAlbum
        imagePickerController.allowsEditing = allowsEditing
        topMostViewController?.present(imagePickerController, animated: true, completion: nil)
    }
}

// MARK:- ImagePicker Delegate -
extension MediaManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true) { [weak self] in
            
            guard let self = self, let commpletion = self.completion else {
                return
            }
            
            var image: UIImage?
            if (self.allowsEditing) {
                image = info[.editedImage] as? UIImage
            } else {
                image = info[.originalImage] as? UIImage
            }
            
            commpletion(image, info)
        }
    }
    
    
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
        }
    }
}


