//
//  PetalSpinner.swift
//  ScalingHeaderScrollView
//
//  Created by Alisa Mylnikova on 07/08/2026.
//  Copyright © 2026 Exyte. All rights reserved.
//

import SwiftUI

struct PetalSpinner: View {

    var progress: CGFloat
    var isSpinning: Bool

    private let petalCount = 8
    @State private var headIndex = 0

    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            ForEach(0..<petalCount, id: \.self) { index in
                RoundedRectangle(cornerRadius: 1)
                    .fill(Color(UIColor.systemGray))
                    .frame(width: 3, height: 9)
                    .offset(y: -9)
                    .rotationEffect(.degrees(Double(index) * (360.0 / Double(petalCount))))
                    .opacity(petalOpacity(for: index))
            }
        }
        .frame(width: 28, height: 28)
        .onReceive(timer) { _ in
            guard isSpinning else { return }
            headIndex = (headIndex + 1) % petalCount
        }
        .onChange(of: isSpinning) { spinning in
            if !spinning { headIndex = 0 }
        }
    }

    private func petalOpacity(for index: Int) -> Double {
        let distance = (index - headIndex + petalCount) % petalCount
        let positionOpacity = Double(petalCount - distance) / Double(petalCount)

        if isSpinning {
            return positionOpacity
        }

        let p = Double(min(progress, 1))
        let filled = p * Double(petalCount)
        let alpha = max(0, min(1, filled - Double(index)))
        return positionOpacity * p * alpha
    }
}
