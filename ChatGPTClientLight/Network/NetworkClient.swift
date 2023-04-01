import Foundation

protocol NetworkClient {
    func fetch<T: Decodable>(request: Request) async -> Result<T, RequestError>
}

extension NetworkClient {

    func fetch<T: Decodable>(request: Request) async -> Result<T, RequestError> {
        guard let url = URL(string: request.baseURL + request.path) else {
            return .failure(.invalidURL)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.header
        urlRequest.httpBody = request.body

        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else {
                    return .failure(.decode)
                }
                return .success(decodedResponse)
            case 401:
                return .failure(.unauthorized)
            default:
                return .failure(.unexpectedStatusCode)
            }
        } catch {
            return .failure(.unknown)
        }
    }
}
