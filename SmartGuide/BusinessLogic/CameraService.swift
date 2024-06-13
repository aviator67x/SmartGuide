//
//  CameraService.swift
//  CustomCamera
//
//  Created by Andrew Kasilov on 04.06.2024.
//

import AVFoundation
import SwiftUI

enum CameraAccessStatus {
    case authorized
    case denied
    case notDetermined
    case restricted
}

final class CameraService: ObservableObject {
    // MARK: - Internal properties

    let previewLayer = AVCaptureVideoPreviewLayer()
    @Published var cameraStatus: CameraAccessStatus = .notDetermined

    // MARK: - Private properties
  
    private var session: AVCaptureSession?
    private var delegate: AVCapturePhotoCaptureDelegate?
    private let output = AVCapturePhotoOutput()
    
    func start(delegate: AVCapturePhotoCaptureDelegate,
               completion: @escaping (Error?) -> ())
    {
        self.delegate = delegate
//        checkPermission(completion: completion)
        setupCamera(completion: completion)
    }
    
    private func checkPermission(completion: @escaping (Error) -> ()) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else {
                    return
                }
                DispatchQueue.main.async {
                    self?.setupCamera(completion: completion)
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setupCamera(completion: completion)
        @unknown default:
            break
        }
    }
    
    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            cameraStatus = .notDetermined
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else {
                    return
                }
                DispatchQueue.main.async {
                    print("Access granted")
                }
            }
        case .restricted:
            cameraStatus = .restricted
        case .denied:
            cameraStatus = .denied
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        case .authorized:
            cameraStatus = .authorized
           
        @unknown default:
            break
        }
    }
    
    private func setupCamera(completion: @escaping (Error) -> ()) {
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                
                if session.canAddOutput(output) {
                    session.addOutput(output)
                }
                
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                
                DispatchQueue.global().async {
                    session.startRunning()
                    self.session = session
                }
                
            } catch {
                completion(error)
            }
        }
    }
    
    func capturePhoto(with settings: AVCapturePhotoSettings = AVCapturePhotoSettings()) {
        guard let delegate = self.delegate else {
            return
        }
        output.capturePhoto(with: settings, delegate: delegate)
    }
    
    deinit {
        print("Camera service deinited")
    }
}
