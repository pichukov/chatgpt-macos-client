struct ChatRequest: Codable {
    let model: String
    let messages: [ChatMessage]
}
