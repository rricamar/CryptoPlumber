import SwiftUI

struct StatisticView: View {
    
    let stat: Statistic
    
    var body: some View {
        VStack (alignment: .leading, spacing: 3) {
            Text(stat.title)
                .font(.caption)
                .foregroundColor(.theme.secondaryText)
            
            Text(stat.value)
                .font(.headline)
                .foregroundColor(.theme.accent)
            
            HStack(spacing: 3) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(
                        Angle(degrees:
                                (stat.change ?? 0) >= 0 ? 0: 180
                             )
                    )
                
                Text(stat.change?.asPercentString() ?? "")
                    .font(.caption)
                    .bold()
                
            }
            .foregroundColor(
                (stat.change ?? 0) >= 0 ? .theme.green : .theme.red
            )
            .opacity(
                stat.change == nil ? 0.0 : 1.0
            )
        }
        .padding(3)
    }
}

struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StatisticView(stat: dev.stat)
                .previewLayout(.sizeThatFits)
            
            StatisticView(stat: dev.stat)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
            
            StatisticView(stat: dev.stat2)
                .previewLayout(.sizeThatFits)
            
            StatisticView(stat: dev.stat3)
                .previewLayout(.sizeThatFits)
            
            StatisticView(stat: dev.stat3)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
        
    }
}
