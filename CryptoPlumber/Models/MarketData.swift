import Foundation

struct GlobalData: Codable {
    let data: MarketDataModel?
}

struct MarketDataModel: Codable {
    let totalMarketCap: [String: Double]
    let totalVolume: [String: Double]
    let marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double
    
    private let UsdCode = "usd"
    private let BtcCode = "btc"
    
    enum CodingKeys: String, CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }
    
    var marketCap: String {
        if let item = totalMarketCap.first(where: { $0.key == UsdCode }) {
            return "$" + item.value.formattedWithAbbreviations()
        } else {
            return ""
        }
    }
    
    var volume: String {
        if let item = totalVolume.first(where: { $0.key == UsdCode }) {
            return "$" + item.value.formattedWithAbbreviations()
        } else {
            return ""
        }
    }
    
    var btcDominance: String {
        if let item = marketCapPercentage.first(where: { $0.key == BtcCode }) {
            return item.value.asPercentString()
        } else {
            return ""
        }
    }
}

