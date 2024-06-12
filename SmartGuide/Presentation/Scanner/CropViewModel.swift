//
//  CropViewModel.swift
//  SmartGuide
//
//  Created by Andrew Kasilov on 11.06.2024.
//

import UIKit
import Vision

final class CropViewModel: ObservableObject {
    @Published var recognizedText: String = ""
    
    init() {
        ocr()
    }
    
    func ocr() {
            let image = UIImage(named: "text")
            
            if let cgImage = image?.cgImage {
                
                // Request handler
                let handler = VNImageRequestHandler(cgImage: cgImage)
                
                let recognizeRequest = VNRecognizeTextRequest { (request, error) in
                    
                    // Parse the results as text
                    guard let result = request.results as? [VNRecognizedTextObservation] else {
                        return
                    }
                    
                    // Extract the data
                    let stringArray = result.compactMap { result in
                        result.topCandidates(1).first?.string
                    }
                    
                    // Update the UI
                    DispatchQueue.main.async {
                        self.recognizedText = stringArray.joined(separator: "\n")
                    }
                }
                
                // Process the request
                recognizeRequest.recognitionLevel = .accurate
                do {
                    try handler.perform([recognizeRequest])
                } catch {
                    print(error)
                }
                
            }
        }
}
