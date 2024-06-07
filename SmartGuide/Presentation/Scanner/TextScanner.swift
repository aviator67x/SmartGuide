//
//  TextScanner.swift
//  CustomCamera
//
//  Created by Andrew Kasilov on 04.06.2024.
//

import AVFoundation
// import SnapToScroll
import SwiftUI

struct TextScanner: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if capturedImage != nil {
                    Image(uiImage: capturedImage!)
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                }
                
                CustomCameraView(capturedImage: $capturedImage)
                    .edgesIgnoringSafeArea(.top)
                
                VStack {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.green, lineWidth: 3)
                        .frame(width: geometry.size.width * 0.8,
                               height: geometry.size.width * 0.5)
                    
                    Text("Place your text within rectangle")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                        .padding()
                    
//                    HSnapScrollView(
//                        itemCount: items.count,
//                        itemWidth: 200,
//                        spaceWidth: 8,
//                        items: self.items, // nails,
//                        id: \.id
//                    ) {
//                        LazyHStack {
//                            ForEach(items, id: \.id) { _ in
//                                Color.red
//                                    .frame(width: 50, height: 30)
//                            }
//                        }
//                    }
//                    HStackSnap(alignment: .leading(16)) {
//                        ForEach(TagModel.exampleModels) { viewModel in
//
//                            TagView(viewModel: viewModel)
//                                .snapAlignmentHelper(id: viewModel.id)
//
//                        }
//                    }.padding(.top, 4)
                    
                    ScrollView(.horizontal) {
                        LazyHStack {
                            Text("First Row")
                                .padding()
                                .foregroundColor(.gray)
                                .background(Color.orange)
                                .cornerRadius(8)
                                  
                            Text("Second Row")
                                .padding()
                                .foregroundColor(.gray)
                                .background(Color.orange)
                                .cornerRadius(8)
                                 
                            Text("Third Row")
                                .padding()
                                .foregroundColor(.gray)
                                .background(Color.orange)
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                    }
                  
                    HStack(spacing: 50) {
                        Button(action: {
                            print("Flash button pressed")
                        }, label: {
                            Image(systemName: "bolt")
                                .font(.system(size: 24))
                                .foregroundColor(.orange)
                                .padding()
                        })
                        
                        Button(action: {
                            print("Import button pressed")
                        }, label: {
                            Text("Import")
                                .font(.system(size: 24))
                                .foregroundColor(.gray)
                                .padding()
                        })
                            .background(Color.orange)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        Button(action: {
                            print("Clock button pressed")
                        }, label: {
                            Image(systemName: "arrow.clockwise.icloud")
                                .font(.system(size: 24))
                                .foregroundColor(.orange)
                                .padding()
                        })
                    }
                    Spacer()
                }
                .frame(height: geometry.size.height * 0.7)
                .offset(y: -50)
            }
        }
    }

    // MARK: - private

    @State private var capturedImage: UIImage?
//    @State private var isCustomCameraViewPresented = false
    
//    let items = [TestModel(name: "first"),
//                 TestModel(name: "second"),
//                 TestModel(name: "third"),
//                 TestModel(name: "fourth"),
//                 TestModel(name: "fifth"),
//                 TestModel(name: "first"),
//                 TestModel(name: "second"),
//                 TestModel(name: "third"),
//                 TestModel(name: "fourth"),
//                 TestModel(name: "fifth")]
}

struct TextScanner_Previews: PreviewProvider {
    static var previews: some View {
        TextScanner()
    }
}

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
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
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
