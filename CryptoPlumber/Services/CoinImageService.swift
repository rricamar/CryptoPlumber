import Foundation
import SwiftUI
import Combine

class CoinImageService {
    
    @Published var image: UIImage? = nil
    
    private var imageSubscription: AnyCancellable?
    private let coin: Coin
    
    private let folderName = "coin_images"
    private let imageName: String
    private let fileManager: LocalFileManager = LocalFileManager.instance
    
    init(coin: Coin) {
        self.coin = coin
        self.imageName = coin.id
        self.getCoinImage()
    }
    
    private func getCoinImage() {
        if let image = fileManager.getImage(imageName: imageName, folderName: folderName) {
            self.image = image
            print("Fetched image from cache → \(imageName)")
        } else {
            self.fetchCoinImage()
            print("Downloading image for → \(imageName)")
        }
    }
    
    private func fetchCoinImage() {
        guard let url = URL(string: coin.image) else { return }
        
        imageSubscription = NetworkManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink(
                receiveCompletion: NetworkManager.handleCompletion,
                receiveValue: { [weak self] (returnedImage) in
                    guard
                        let self = self,
                        let downloadedImage = returnedImage
                    else { return }
                    
                    self.image = returnedImage
                    self.imageSubscription?.cancel()
                    
                    self.fileManager.saveImage(
                        image: downloadedImage,
                        imageName: self.imageName,
                        folderName: self.folderName
                    )
                }
            )
    }
    
}
