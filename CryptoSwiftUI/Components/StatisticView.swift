//
//  StatisticView.swift
//  CryptoSwiftUI
//
//  Created by Bengi Anıl on 28.03.2024.
//

import SwiftUI

struct StatisticView: View {
    let statistic: StatisticModel
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(statistic.title)
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
            
            Text(statistic.value)
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
            
            HStack(spacing: 4) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(Angle(degrees: (statistic.percentageChange ?? 0) >= 0 ? 0 : 180))
                
                Text(statistic.percentageChange?.percentString() ?? "")
                    .font(.caption)
                    .bold()
            }
            .foregroundStyle((statistic.percentageChange ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
            .opacity(statistic.percentageChange == nil ? 0 : 1)
        }
    }
}

#Preview {
    StatisticView(statistic: Preview.instance.statistic)
}
