//
//  ChatGPTViewModel.swift
//  SmartGuide
//
//  Created by Andrew Kasilov on 17.06.2024.
//

import Foundation

final class ChatGPTViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var currentInput: String = ""
    
    private let openAIService = OpenAIService()
    
    func sendMessage() {
        let newMessage = Message(id: UUID(), role: .user, content: currentInput, createdAt: Date())
        messages.append(newMessage)
        currentInput = ""
        
        Task {
            let response = await openAIService.sendMessage(messages: messages)
            guard let receivedOpenAIMessage = response?.choices.first?.message else {
                print("Had no received messages")
                return
            }
            let receivedMessage = Message(id: UUID(), role: receivedOpenAIMessage.role, content: receivedOpenAIMessage.content, createdAt: Date())
            
            await MainActor.run {
                messages.append(receivedMessage)
            }
        }
    }
}

struct Message: Decodable {
    let id: UUID
    let role: SenderRole
    let content: String
    let createdAt: Date
}
