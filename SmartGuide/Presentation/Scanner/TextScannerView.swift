//
//  TextScanner.swift
//  CustomCamera
//
//  Created by Andrew Kasilov on 04.06.2024.
//

import AVFoundation
// import SnapToScroll
import SwiftUI

struct TextScannerView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                upperButtonsStack()
                
                Spacer()
                
                downButtonsStack()
            }
            .frame(maxHeight: .infinity)
            .background(
                VStack {
                    if capturedImage != nil {
                        Image(uiImage: capturedImage!)
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
                    }
                        
                    if isCameraShown {
                        ZStack {
                            CustomCameraView(capturedImage: $capturedImage)
                                .edgesIgnoringSafeArea(.top)
                            
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.green, lineWidth: 3)
                                .frame(width: geometry.size.width * 0.8,
                                       height: geometry.size.width * 0.5)
                            
                            Text("Place your text within rectangle")
                                .font(.system(size: 24))
                                .foregroundColor(.gray)
                                .padding()
                        }
                       
                    } else {
                        Color.black
                            .ignoresSafeArea()
                    }
                }
            )
        }
    }

    // MARK: - private

    @StateObject private var model = TextScannerViewModel()

    @State private var isCameraShown = false
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

// MARK: - private extension

private extension TextScannerView {
    @ViewBuilder
    func upperButtonsStack() -> some View {
        HStack {
            Button(action: {
                print("Flash button pressed")
                model.changeFlashMode()
                
            }, label: {
                Image(systemName: model.flashMode.imageName)
                    .imageScale(.large)
                    .foregroundColor(.white)
                    .padding()
            })
                
            Spacer()

            Menu {
                Button {
                    model.contactSupportX()
                } label: {
                    Label("Contact Support on X", systemImage: "xmark.rectangle.fill")
                }
                Button {
                    model.sendEmail()
                } label: {
                    Label("Send Email to Support", systemImage: "envelope.fill")
                }
            } label: {
                Label("", systemImage: "line.horizontal.3")
                    .foregroundColor(.white)
                    .padding()
            }
        }
    }
    
    @ViewBuilder
    func downButtonsStack() -> some View {
        VStack {
            Button(action: {
                print("Import button pressed")
            }) {
                Text("Import")
                    .frame(maxWidth: .infinity)
                    .font(.system(size: 18, weight: .bold))
                    .padding(10)
                    .foregroundColor(.white)
                    .background(Color.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
            }
            .frame(height: 50)
            .padding()
            
            Button(action: {
                print("History button pressed")
            }) {
                Text("History")
                    .frame(maxWidth: .infinity)
                    .font(.system(size: 18, weight: .bold))
                    .padding(10)
                    .foregroundColor(.white)
                    .background(Color.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
            }
            .frame(height: 50)
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
    }
    
    @ViewBuilder
    func scrollingButtons() -> some View {
//        HSnapScrollView(
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
    }
}

struct TextScanner_Previews: PreviewProvider {
    static var previews: some View {
        TextScannerView()
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
