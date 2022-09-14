import Foundation

struct Statistic: Identifiable {
    let id = UUID().uuidString
    
    let title: String
    let value: String
    let change: Double?
    
    init(title: String, value: String, change: Double? = nil) {
        self.title = title
        self.value = value
        self.change = change
    }
}
