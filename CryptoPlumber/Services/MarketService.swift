import Foundation
import Combine

class MarketService {
    
    @Published var marketData: MarketDataModel? = nil
    
    var marketSubscription: AnyCancellable?
    
    fileprivate static let apiUrl = "https://api.coingecko.com/api/v3/global"
    
    init() {
        getData()
    }
    
    private func getData() {
        guard let url = URL(string: MarketService.apiUrl)
        else {
            return
        }
        
        marketSubscription = NetworkManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(
                receiveCompletion: NetworkManager.handleCompletion,
                receiveValue: { [weak self] (globalData) in
                    self?.marketData = globalData.data
                    self?.marketSubscription?.cancel()
                })
    }
    
}
