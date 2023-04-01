import SwiftUI

class ContentViewModel: ObservableObject {

    @Published var isChatsSelected = false
    @Published var isSettingsSelected = false
    
    private let network: Network
    private lazy var sessionViewModel = SessionViewModel(
        network: network,
        tokenDelegate: self
    )

    init() {
        isChatsSelected = true
        network = Network()
        API.token = getToken()
    }

    func getSessionViewModel() -> SessionViewModel {
        return sessionViewModel
    }
}

protocol TokenDelegate: AnyObject {
    func update(token: String)
    func getToken() -> String
    func isTokenAvailable() -> Bool
}

extension ContentViewModel: TokenDelegate {

    func update(token: String) {
        UserDefaults.standard.set(token, forKey: StoreKeys.token.rawValue)
        API.token = token
    }

    func getToken() -> String {
        return UserDefaults.standard.string(forKey: StoreKeys.token.rawValue) ?? ""
    }

    func isTokenAvailable() -> Bool {
        let token = getToken()
        return !token.isEmpty
    }
}
