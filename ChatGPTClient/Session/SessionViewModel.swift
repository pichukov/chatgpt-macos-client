//
//  SessionViewModel.swift
//  ChatGPTClient
//
//  Created by Alexey Pichukov on 01.04.2023.
//

import Combine
import Foundation

class SessionViewModel: ObservableObject {

    @Published var message: String = ""
    @Published var chatItems: [ChatItem] = []
    @Published var isLoading = false
    @Published var ready = false

    private let network: NetworkClient
    private weak var tokenDelegate: TokenDelegate?

    init(network: NetworkClient = Network(), tokenDelegate: TokenDelegate? = nil) {
        self.network = network
        self.tokenDelegate = tokenDelegate
        ready = tokenDelegate?.isTokenAvailable() ?? false
    }

    func checkToken() {
        ready = tokenDelegate?.isTokenAvailable() ?? false
    }

    func reset(fromID id: String) {
        for i in 0..<chatItems.count {
            guard chatItems[i].id == id, i < chatItems.count - 1 else {
                continue
            }
            let range = i+1...chatItems.count - 1
            chatItems.removeSubrange(range)
            return
        }
    }

    func request() {
        isLoading = true
        let questionBlocks = AnswerConverter.splitToBlocks(string: message)
        chatItems.append(
            .init(
                date: Date(),
                role: .user,
                blocks: questionBlocks,
                raw: message
            )
        )
        message = ""
        Task {
            let result: Result<ChatResponse, RequestError> = await network.fetch(
                request: API.completions(
                    ChatRequest(
                        model: "gpt-3.5-turbo",
                        messages: chatItems.map { ChatMessage(role: $0.role, content: $0.raw) }
                    )
                )
            )
            await MainActor.run {
                isLoading = false
                switch result {
                case .success(let response):
                    guard let message = response.choices.first?.message.content else { return }
                    let answerBlocks = AnswerConverter.splitToBlocks(string: message)
                    chatItems.append(
                        .init(
                            date: Date(),
                            role: .assistant,
                            blocks: answerBlocks,
                            raw: message
                        )
                    )
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
