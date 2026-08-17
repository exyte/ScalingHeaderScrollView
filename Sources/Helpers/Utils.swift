//
//  Utils.swift
//  ScalingHeaderScrollView
//
//  Created by Alisa Mylnikova on 04.08.2026.
//

import SwiftUI
import UIKit

@MainActor
func snapScrollPosition(in scrollView: UIScrollView?, params: ScalingHeaderParameters) {
    guard let sv = scrollView else { return }
    let extraSpace = params.maxHeight - params.minHeight
    let offset = sv.contentOffset.y
    for i in 0..<params.headerSnappingPositions.count - 1 {
        let first = -params.maxHeight + params.headerSnappingPositions[i] * extraSpace
        let second = -params.maxHeight + params.headerSnappingPositions[i + 1] * extraSpace
        guard offset > first, offset < second else { continue }
        let result = abs(offset - first) < abs(offset - second) ? first : second
        sv.setContentOffset(CGPoint(x: 0, y: result), animated: true)
        return
    }
}

// MARK: -

extension View {

    @ViewBuilder
    func clipped(isClipped: Bool) -> some View {
        if isClipped {
            self.clipped()
        } else {
            self
        }
    }
}
