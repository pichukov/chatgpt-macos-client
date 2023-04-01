import Foundation

protocol Request {
    var baseURL: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var body: Data? { get }
}

extension Request {
    func encode<T: Encodable>(_ value: T) -> Data? {
        return try? JSONEncoder().encode(value)
    }
}
