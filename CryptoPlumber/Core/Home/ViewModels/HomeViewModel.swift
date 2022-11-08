import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    @Published var statistics: [Statistic] = []
    
    @Published var searchText: String = ""
    
    private let coinService = CoinService()
    private let marketService = MarketService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        subscribe()
    }
    
    func subscribe() {
        subscribeCoinData()
        subscribeMarketData()
    }
    
    private func subscribeCoinData() {
        $searchText
            .combineLatest(coinService.$coins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] (filteredCoins) in
                self?.allCoins = filteredCoins
            }
            .store(in: &cancellables)
    }
    
    private func subscribeMarketData() {
        marketService.$marketData
            .map(mapMarketData)
            .sink { [weak self] (statistics) in
                self?.statistics = statistics
            }
            .store(in: &cancellables)
    }
    
    private func filterCoins(search: String, coins: [Coin]) -> [Coin] {
        if search.isEmpty {
            return coins
        } else {
            return coins.filter {
                $0.name.lowercased().contains(search.lowercased()) ||
                $0.symbol.lowercased().contains(search.lowercased()) ||
                $0.id.lowercased().contains(search.lowercased())
            }
        }
    }
    
    private func mapMarketData(marketData: MarketDataModel?) -> [Statistic] {
        var statistics: [Statistic] = []
        
        guard let data = marketData
        else {
            return statistics
        }
        
        let marketCap = Statistic(
            title: "Market Cap", value: data.marketCap, change: data.marketCapChangePercentage24HUsd)
        
        let volume = Statistic(title: "24h Volume", value: data.volume)
        let btcDominance = Statistic(title: "BTC Dominance", value: data.btcDominance)
        let portfolio = Statistic(title: "Portfolio Value", value: "$0.0", change: 0)
        
        statistics.append(contentsOf: [marketCap, volume, btcDominance, portfolio])
        return statistics
    }
}
