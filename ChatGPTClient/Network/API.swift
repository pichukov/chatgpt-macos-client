import Foundation

enum API {
    case completions(ChatRequest)

    static var url = "https://api.openai.com/v1"
    static var token = ""
}

extension API: Request {

    var baseURL: String {
        return API.url
    }

    var path: String {
        switch self {
        case .completions: return "/chat/completions"
        }
    }

    var method: RequestMethod {
        return .post
    }

    var header: [String: String]? {
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(API.token)"
        ]
    }

    var body: Data? {
        switch self {
        case .completions(let item): return encode(item)
        }
    }
}
