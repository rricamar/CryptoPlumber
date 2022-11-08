import Foundation
import Combine

class CoinService {
    
    @Published var coins: [Coin] = []
    
    var coinSubscription: AnyCancellable?
    
    fileprivate static let apiUrl =
    "https://api.coingecko.com/api/v3/coins/markets"
    + "?vs_currency=usd"
    + "&order=market_cap_desc"
    + "&per_page=250"
    + "&page=1"
    + "&sparkline=true"
    + "&price_change_percentage=24h"
    
    init() {
        list()
    }
    
    private func list() {
        guard let url = URL(string: CoinService.apiUrl) else { return }
        
        coinSubscription = NetworkManager.download(url: url)
            .decode(type: [Coin].self, decoder: JSONDecoder())
            .sink(
                receiveCompletion: NetworkManager.handleCompletion,
                receiveValue: { [weak self] (coins) in
                    self?.coins = coins
                    self?.coinSubscription?.cancel()
                }
            )
    }
    
}
