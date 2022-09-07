import SwiftUI


struct CoinRowView: View {
    
    let coin: Coin
    let showHoldingsColumn: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            leftPart
            
            Spacer()
            
            if showHoldingsColumn {
                centerPart
            }
            
            rightPart
        }
        .font(.subheadline)
    }
    
}


extension CoinRowView {
    
    private var leftPart: some View {
        HStack(spacing: 0){
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(.theme.secondaryText)
                .frame(minWidth: 30)
            
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            
            Text("\(coin.symbol.uppercased())")
                .font(.headline)
                .padding(.leading, 5)
                .foregroundColor(.theme.accent)
        }
    }
    
    private var centerPart: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentHoldingValue.asCurrencyWith6Decimals())
                .bold()
            
            Text((coin.currentHoldings ?? 0).asNumberString())
        }
        .foregroundColor(.theme.accent)
    }
    
    private var rightPart: some View {
        VStack(alignment: .trailing) {
            Text((coin.currentPrice.asCurrencyWith6Decimals()))
                .bold()
                .foregroundColor(.theme.accent)
            
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                .foregroundColor(
                    (coin.getPriceChangePercentage24H >= 0)
                    ? .theme.green
                    : .theme.red
                )
        }
        .frame(
            width: UIScreen.main.bounds.width / 3.5,
            alignment: .trailing
        )
    }
}


struct CoinRowView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            CoinRowView(
                coin: dev.coin,
                showHoldingsColumn: true
            )
            .previewLayout(.sizeThatFits)
            
            CoinRowView(
                coin: dev.coin,
                showHoldingsColumn: false
            )
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
        }
        
    }
    
}
