//
//  CameraView.swift
//  SmartGuide
//
//  Created by Andrew Kasilov on 13.06.2024.
//

import AVFoundation
import SwiftUI

struct CameraView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    
    let cameraService: CameraService
    let didFinishProcessingPhoto: (Result<AVCapturePhoto, Error>) -> ()
    
    func makeUIViewController(context: Context) -> UIViewController {
        cameraService.start(delegate: context.coordinator) { err in
            if let err {
                return didFinishProcessingPhoto(.failure(err))
            }
        }
        
        let viewController = UIViewController()
        viewController.view.backgroundColor = .black
        viewController.view.layer.addSublayer(cameraService.previewLayer)
        cameraService.previewLayer.frame = viewController.view.bounds
        return viewController
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, didFinishProcessingPhoto: didFinishProcessingPhoto)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

final class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {
    let parent: CameraView
    private var didFinishProcessingPhoto: (Result<AVCapturePhoto, Error>) -> ()
        
    init(_ parent: CameraView,
         didFinishProcessingPhoto: @escaping (Result<AVCapturePhoto, Error>) -> ())
    {
        self.parent = parent
        self.didFinishProcessingPhoto = didFinishProcessingPhoto
    }
        
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error {
            return didFinishProcessingPhoto(.failure(error))
        }
        didFinishProcessingPhoto(.success(photo))
    }

    deinit {
        print("Coordinator deinited")
    }
}
