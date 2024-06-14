//
//  TextScanner.swift
//  CustomCamera
//
//  Created by Andrew Kasilov on 04.06.2024.
//

// import SnapToScroll
import SwiftUI

struct TextScannerView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    upperButtonsStack(geometry: geometry)
                   
                    cameraTools(geometry: geometry)
                    
                    downButtonsStack()
                }
                .frame(maxHeight: .infinity)
                .padding(.bottom, geometry.size.height * 0.015)
            }
            .edgesIgnoringSafeArea(.top)
            .background(
                VStack {
                    if model.cameraAccessStatus == .authorized {
                        CameraView(cameraService: cameraService,
                                   didFinishProcessingPhoto: { result in
                                       switch result {
                                       case .success(let photo):
                                           if let data = photo.fileDataRepresentation() {
                                               capturedImage = UIImage(data: data)
                                               coordinator.push(.crop(capturedImage ?? UIImage()))
                                           } else {
                                               print("Error: no image data found")
                                           }
                                
                                       case .failure(let error):
                                           print(error.localizedDescription)
                                       }
                                   })
                       
                    } else {
                        Color.black
                    }
                }
                .ignoresSafeArea()
            )
            .overlay {
                if model.cameraAccessStatus != .authorized {
                    cameraPermissionPopup()
                }
            }
        }
    }

    // MARK: - internal properties

    @ObservedObject var cameraService: CameraServiceImpl

    // MARK: - private properties

    @StateObject private var model: TextScannerViewModel

    @EnvironmentObject private var coordinator: ScannerCoordinator

    @State private var capturedImage: UIImage?

    // MARK: - Life cycle

    init(cameraService: CameraServiceImpl) {
        self.cameraService = cameraService
        _model = StateObject(wrappedValue: TextScannerViewModel(cameraService: cameraService))
    }
    
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
    func upperButtonsStack(geometry: GeometryProxy) -> some View {
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
        .padding(.bottom, geometry.size.height * 0.015)
    }
    
    @ViewBuilder
    func cameraTools(geometry: GeometryProxy) -> some View {
        VStack {
            VStack {
                HStack {
                    Image("leftCorner")
                    Spacer()
                    Image("rightCorner")
                }
                Spacer()
                HStack {
                    Image("leftDownCorner")
                    Spacer()
                    Image("rightDownCorner")
                }
            }
            .frame(width: geometry.size.width * 0.9,
                   height: geometry.size.height * 0.4)
            Group {
                Text("Place your text within rectangle and")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                
                Text("Tap the  button")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                
                Button(action: {
                    cameraService.capturePhoto()
                }, label: {
                    Image(systemName: "circle")
                        .font(.system(size: geometry.size.height * 0.11))
                        .foregroundColor(.white)
                })
            }
            .offset(y: -(geometry.size.height * 0.03))
        }
        .opacity(model.cameraAccessStatus == .authorized ? 1 : 0)
        .padding(.bottom, 10)
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
            .padding(.horizontal)
            .padding(.bottom, 10)
            
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
    
    @ViewBuilder
    func cameraPermissionPopup() -> some View {
        VStack {
            Text("Enable Camera")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.white)
            
            Text("to let SmartGuide to provide you tips about all interesting topics")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
            
            Button(action: {
                print("Grant access button pressed")
                model.requestCameraAccess()
            }) {
                Text(model.cameraAccessStatus == .notDetermined ? "Grant access" : "Fix camera access")
                    .frame(maxWidth: .infinity)
                    .font(.system(size: 18, weight: .bold))
                    .padding(10)
//                    .foregroundColor(.white)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
            }
            .frame(height: 50)
            .padding()
        }
        .padding(.horizontal, 32)
        .padding(.bottom, 300)
    }
}

struct TextScanner_Previews: PreviewProvider {
    static var previews: some View {
        TextScannerView(cameraService: CameraServiceImpl())
    }
}
