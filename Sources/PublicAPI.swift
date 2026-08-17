//
//  PublicAPI.swift
//  ScalingHeaderScrollView
//

import SwiftUI

// MARK: - Protocol

@MainActor
public protocol ScalingHeaderViewAPI: View {
    var params: ScalingHeaderParameters { get set }
}

// MARK: - Modifiers

extension ScalingHeaderViewAPI {

    /// Passes current collapse progress (0 = expanded, 1 = collapsed) into binding
    public func collapseProgress(_ progress: Binding<CGFloat>) -> Self {
        var view = self
        view.params.collapseProgress = progress
        return view
    }

    /// Passes current scroll offset into binding
    public func scrollOffset(_ offset: Binding<CGFloat>) -> Self {
        var view = self
        view.params.scrollOffset = offset
        return view
    }

    /// Allows scroll-to-top reset; set Binding to `true` to trigger
    public func scrollToTop(resetScroll: Binding<Bool>) -> Self {
        var view = self
        view.params.scrollToTop = resetScroll
        return view
    }

    /// When scrolling down - enable/disable header growth beyond maxHeight
    public func allowsHeaderGrowth(_ allows: Bool = true) -> Self {
        var view = self
        view.params.allowsHeaderGrowthFlag = allows
        return view
    }

    /// When scrolling up - enable/disable header collapse to minHeight
    public func allowsHeaderCollapse(_ allows: Bool = true) -> Self {
        var view = self
        view.params.allowsHeaderCollapseFlag = allows
        return view
    }

    /// Hides scroll indicators
    public func hideScrollIndicators(_ hide: Bool = true) -> Self {
        var view = self
        view.params.showsIndicators = !hide
        return view
    }

    /// Controls whether the header clips its content
    public func headerIsClipped(_ isClipped: Bool = true) -> Self {
        var view = self
        view.params.headerIsClipped = isClipped
        return view
    }

    /// Sets the alignment of content inside the header frame
    public func headerAlignment(_ alignment: Alignment) -> Self {
        var view = self
        view.params.headerAlignment = alignment
        return view
    }

    /// Called when the scroll view reaches the bottom
    public func scrollViewDidReachBottom(perform: @escaping () -> Void) -> Self {
        var view = self
        view.params.didReachBottom = perform
        return view
    }

    /// Programmatically snap the header to a specific state, with optional animation
    public func snapHeaderToState(_ state: Binding<SnapHeaderState?>, animated: Bool = true) -> Self {
        var view = self
        view.params.headerAnimation = animated ? .default : nil
        view.params.shouldSnapTo = state
        return view
    }

    /// Set initial scroll position expressed as a collapse fraction (0 = expanded, 1 = collapsed)
    public func initialSnapPosition(initialSnapPosition: CGFloat) -> Self {
        var view = self
        view.params.initialSnapPosition = initialSnapPosition
        return view
    }

    /// Allows to set up callback and `isLoading` state for pull-to-refresh action
    public func pullToRefresh(isActive: Bool = true, perform: @escaping () async -> Void) -> Self {
        var view = self
        view.params.isPullToRefreshEnabled = isActive
        view.params.didPullToRefresh = perform
        return view
    }

    /// Allows to set up callback and `isLoading` state for pull-to-load-more action
    public func pullToLoadMore(isActive: Bool = true, contentOffset: CGFloat = 0, perform: @escaping () async -> Void) -> Self {
        var view = self
        view.params.isPullToLoadMoreEnabled = isActive
        view.params.pullToLoadMoreContentOffset = contentOffset
        view.params.didPullToLoadMore = perform
        return view
    }

    /// Enable/disable header snap with snap mode selection
    /// - Parameter mode: Options for modes. Details see in ``SnapHeaderMode``
    public func setHeaderSnapMode(_ mode: SnapHeaderMode) -> Self {
        var view = self
        switch mode {
        case .disabled:
            view.params.headerSnappingPositions = []
            view.params.headerSnappingShouldWaitFinishAccelerating = false
        case .immediately:
            if view.params.headerSnappingPositions.isEmpty {
                view.params.headerSnappingPositions = [0, 1]
            }
            view.params.headerSnappingShouldWaitFinishAccelerating = false
        case .afterFinishAccelerating:
            if view.params.headerSnappingPositions.isEmpty {
                view.params.headerSnappingPositions = [0, 1]
            }
            view.params.headerSnappingShouldWaitFinishAccelerating = true
        }
        return view
    }

    /// Set positions for header snap (once you lift your finger header snaps to closest allowed position)
    public func headerSnappingPositions(snapPositions: [CGFloat]) -> Self {
        var view = self
        view.params.headerSnappingPositions = snapPositions
        return view
    }

    /// Enable header snap (once you lift your finger header snaps either to min or max height automatically)
    @available(*, deprecated, message: "Use `setHeaderSnapMode()` instead. Will be removed in future releases.")
    public func allowsHeaderSnap() -> Self {
        setHeaderSnapMode(.immediately)
    }

    /// Changes min and max heights of the header. Prefer passing these in the initializer instead.
    @available(*, deprecated, message: "Pass minHeight and maxHeight in the initializer instead.")
    public func height(min: CGFloat = 150.0, max: CGFloat = 350.0) -> Self {
        var view = self
        view.params.minHeight = min
        view.params.maxHeight = max
        return view
    }
}
