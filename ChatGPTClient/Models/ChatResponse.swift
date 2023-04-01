struct ChatResponse: Codable {
    let id: String
    let object: String
    let choices: [ChatResponseChoice]
}

struct ChatResponseChoice: Codable {
    let index: Int
    let message: ChatMessage
}
