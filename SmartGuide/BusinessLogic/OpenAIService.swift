//
//  OpenAIService.swift
//  SmartGuide
//
//  Created by Andrew Kasilov on 17.06.2024.
//

import Alamofire
import Foundation

final class OpenAIService {
    private let endPointUrl = "https://api.openai.com/v1/chat/completions"

    func sendMessage(messages: [Message]) async -> OpenAIChatResponce? {
        let openAIMessages = messages.map { OpenAIChatMessage(role: $0.role, content: $0.content) }

        let body = OpenAIChatBody(model: "gpt-3.5-turbo-16k", messages: openAIMessages)
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Constants.openApiKey)"
        ]
        return try? await AF.request(endPointUrl, method: .post, parameters: body, encoder: .json, headers: headers).serializingDecodable(OpenAIChatResponce.self).value
    }
}

struct OpenAIChatBody: Encodable {
    let model: String
    let messages: [OpenAIChatMessage]
}

struct OpenAIChatMessage: Codable {
    let role: SenderRole
    let content: String
}

enum SenderRole: String, Codable {
    case system
    case user
    case assistant
}

struct OpenAIChatResponce: Decodable {
    let choices: [OpenAIChatChoice]
}

struct OpenAIChatChoice: Decodable {
    let message: OpenAIChatMessage
}

enum Constants {
    static let openApiKey = ""
}
