//
//  CustomCameraView.swift
//  CustomCamera
//
//  Created by Andrew Kasilov on 04.06.2024.
//

import SwiftUI

struct CustomCameraView: View {
    var body: some View {
        ZStack {
            CameraView(cameraService: cameraService,
                       didFinishProcessingPhoto: { result in
                switch result {
                case .success(let photo):
                    if let data = photo.fileDataRepresentation() {
                        capturedImage = UIImage(data: data)
                        presentationMode.wrappedValue.dismiss()
                        coordinator.push(.crop(capturedImage ?? UIImage()))
                    } else {
                        print("Error: no image data found")
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
            
            VStack {
                Spacer()
                
             Button(action: {
                 cameraService.capturePhoto()
             }, label: {
                 Image(systemName: "circle")
                     .font(.system(size: 72))
                     .foregroundColor(.white)
             })
             .padding(.bottom)
            }
        }
    }
    // MARK: - private
    @StateObject var cameraService = CameraService()
    @Binding var capturedImage: UIImage?
    
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var coordinator: ScannerCoordinator
}

//struct CustomCameraView_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomCameraView(capturedImage: <#Binding<UIImage?>#>)
//    }
//}
