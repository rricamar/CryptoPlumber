import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    
    // TODO: remove on next version (debug only)
    @Published var statistics: [Statistic] = [
        Statistic(title: "Title", value: "Value", change: 1),
        Statistic(title: "Title", value: "Value"),
        Statistic(title: "Title", value: "Value"),
        Statistic(title: "Title", value: "Value", change: -1)
    ]
    
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    
    @Published var searchText: String = ""
    
    private let service = CoinService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        subscribe()
    }
    
    func subscribe() {
        $searchText
            .combineLatest(service.$coins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] (filteredCoins) in
                self?.allCoins = filteredCoins
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
}
