import Foundation
import Combine

class NetworkManager {
    
    enum NetworkError: LocalizedError {
        case badUrlResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badUrlResponse(url: let url): return "[🔥] Bad response from Url: \(url)"
            case .unknown: return "[⚠️] Unknown error occured"
            }
        }
    }
    
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(
                on: DispatchQueue.global(qos: .default)
            )
            .tryMap({ try handleResponse(output: $0, url: url) })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func handleResponse(
        output: URLSession.DataTaskPublisher.Output,
        url: URL
    ) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              NetworkManager.responseWithoutError(response)
        else {
            throw NetworkManager.NetworkError.badUrlResponse(url: url)
        }
        
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    fileprivate static func responseWithoutError(_ response: HTTPURLResponse) -> Bool {
        return response.statusCode >= 200 && response.statusCode < 300
    }
    
}
