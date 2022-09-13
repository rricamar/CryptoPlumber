import SwiftUI
import Combine


class HomeViewModel: ObservableObject {
    
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    
    @Published var searchText: String = ""
    
    private let service = CoinService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        subscribe()
    }
    
    
    func subscribe() {
        service.$coins
            .sink { [weak self] (coins) in
                self?.allCoins = coins
            }
            .store(in: &cancellables)
    }
    
}
