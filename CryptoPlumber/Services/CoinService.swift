import Foundation
import Combine


class CoinService {
    
    @Published var coins: [Coin] = []
    
    var coinSubscription: AnyCancellable?
    
    init() {
        list()
    }
    
    private func list() {
        let apiUrl = getApiUrl()
        
        guard let url = URL(string: apiUrl) else { return }
        
        coinSubscription = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(
                on: DispatchQueue.global(qos: .default)
            )
            .tryMap { (output) -> Data in
                guard let response = output.response as? HTTPURLResponse,
                      self.responseWithoutError(response)
                else {
                    throw URLError(.badServerResponse)
                }
                
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .decode(type: [Coin].self, decoder: JSONDecoder())
            .sink { (completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] (coins) in
                self?.coins = coins
                self?.coinSubscription?.cancel()
            }
    }
    
    fileprivate func getApiUrl() -> String {
        return "https://api.coingecko.com/api/v3/coins/markets"
        + "?vs_currency=usd"
        + "&order=market_cap_desc"
        + "&per_page=250"
        + "&page=1"
        + "&sparkline=true"
        + "&price_change_percentage=24h"
    }
    
    fileprivate func responseWithoutError(_ response: HTTPURLResponse) -> Bool {
        return response.statusCode >= 200 && response.statusCode < 300
    }
    
}
