//
//  ChatGPTView.swift
//  SmartGuide
//
//  Created by Andrew Kasilov on 17.06.2024.
//

import SwiftUI

struct ChatGPTView: View {
    var body: some View {
        VStack {
            ScrollView {
                ForEach(viewModel.messages, id: \.id) { message in
                    messageView(message: message)
                }
            }
            HStack {
                TextField("Enter a message", text: $viewModel.currentInput)
                Button {
                    viewModel.sendMessage()
                } label: {
                    Text("Send")
                }
            }
        }
    }
    
    @ObservedObject var viewModel = ChatGPTViewModel()
    
    @ViewBuilder
    func messageView(message: Message) -> some View {
        HStack {
            if message.role == .user {
                Spacer()
                Text(message.content)
            }
            if message.role == .assistant {
                Spacer()
            }
        }
    }
}

struct ChatGPTView_Previews: PreviewProvider {
    static var previews: some View {
        ChatGPTView()
    }
}
