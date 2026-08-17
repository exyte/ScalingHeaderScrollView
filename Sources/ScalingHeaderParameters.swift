//
//  ScalingHeaderParameters.swift
//  ScalingHeaderScrollView
//

import SwiftUI

public struct ScalingHeaderParameters {
    public var minHeight: CGFloat
    public var maxHeight: CGFloat
    public var allowsHeaderCollapseFlag: Bool = true
    public var allowsHeaderGrowthFlag: Bool = false
    public var showsIndicators: Bool = true
    public var headerIsClipped: Bool = true
    public var headerAlignment: Alignment
    public var headerAnimation: Animation?
    public var headerSnappingPositions: [CGFloat] = []
    public var headerSnappingShouldWaitFinishAccelerating: Bool = false
    public var initialSnapPosition: CGFloat?
    public var isPullToRefreshEnabled: Bool = true
    public var isPullToLoadMoreEnabled: Bool = true
    public var pullToLoadMoreContentOffset: CGFloat = 0.0
    public var didPullToRefresh: (() async -> Void)?
    public var didPullToLoadMore: (() async -> Void)?
    public var didReachBottom: (() -> Void)?

    public var collapseProgress: Binding<CGFloat> = .constant(0)
    public var scrollOffset: Binding<CGFloat> = .constant(0)
    public var scrollToTop: Binding<Bool> = .constant(false)
    public var shouldSnapTo: Binding<SnapHeaderState?> = .constant(nil)

    public init(minHeight: CGFloat = 150, maxHeight: CGFloat = 350, headerAlignment: Alignment = .center) {
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self.headerAlignment = headerAlignment
    }
}

// MARK: -

public enum SnapHeaderState: Equatable {
    case expanded
    case collapsed
    case custom(CGFloat)
}

public enum SnapHeaderMode: Int {
    /// Disable header snap.
    case disabled

    /// Enable header snap.
    /// Once you lift your finger header snaps either to min or max height automatically.
    case immediately

    /// Enable header snap. Smoother scroll mode.
    /// At the end of scroll view deceleration the header snaps either to min or max height automatically.
    case afterFinishAccelerating
}

final class ScalingHeaderScrollViewStore: ObservableObject {
    @Published var currentRawOffset: CGFloat
    weak var uiScrollView: UIScrollView?

    init(initialMaxHeight: CGFloat) {
        self.currentRawOffset = -initialMaxHeight
    }
}

struct TabScrollState {
    var scrollView: UIScrollView?
    var offset: CGFloat = 0
}

final class TabScrollStates<Tab: Hashable> {
    var states: [Tab: TabScrollState] = [:]
}
