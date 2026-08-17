//
//  ScalingHeaderScrollView.swift
//  ScalingHeaderScrollView
//
//  Created by Alisa Mylnikova on 16/09/2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import SwiftUI

public struct ScalingHeaderScrollView<Header: View, Content: View>: ScalingHeaderViewAPI {

    var header: (CGFloat, CGFloat) -> Header
    var content: Content

    public var params: ScalingHeaderParameters

    @StateObject private var store: ScalingHeaderScrollViewStore
    @State private var acceleration: CGFloat = 0

    // MARK: - Init

    public init(
        minHeight: CGFloat = 150,
        maxHeight: CGFloat = 350,
        @ViewBuilder header: @escaping (CGFloat, CGFloat) -> Header,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.params = ScalingHeaderParameters(minHeight: minHeight, maxHeight: maxHeight)
        self.header = header
        self.content = content()
        _store = StateObject(wrappedValue: ScalingHeaderScrollViewStore(initialMaxHeight: maxHeight))
    }

    // MARK: - Private computed

    private var computedInitialOffset: CGFloat {
        guard let pos = params.initialSnapPosition else { return -params.maxHeight }
        return -params.maxHeight + pos * (params.maxHeight - params.minHeight)
    }

    private var currentHeaderHeight: CGFloat {
        if !params.allowsHeaderCollapseFlag { return params.maxHeight }
        let raw = -store.currentRawOffset
        if params.allowsHeaderGrowthFlag && params.didPullToRefresh == nil {
            return max(params.minHeight, raw)
        }
        return max(params.minHeight, min(params.maxHeight, raw))
    }

    // MARK: - Body

    public var body: some View {
        ScalingHeaderCore(
            header: header,
            contentBuilder: { triggerRefresh, triggerLoadMore, onDragProgress in
                PageScrollView(
                    topInset: params.maxHeight,
                    minInset: params.minHeight,
                    initialOffset: computedInitialOffset,
                    onScrollViewReady: { sv in
                        guard store.uiScrollView == nil else { return }
                        store.uiScrollView = sv
                    },
                    onOffsetChange: { offset, _ in
                        DispatchQueue.main.async {
                            store.currentRawOffset = offset
                            params.scrollOffset.wrappedValue = offset
                        }
                    },
                    onWillEndDragging: { velocity in
                        acceleration = velocity
                    },
                    onEndDragging: {
                        guard !params.headerSnappingPositions.isEmpty else { return }
                        if !params.headerSnappingShouldWaitFinishAccelerating || abs(acceleration) < 0.2 {
                            snapScrollPosition(in: store.uiScrollView, params: params)
                        }
                    },
                    onEndDecelerating: {
                        if params.headerSnappingShouldWaitFinishAccelerating && !params.headerSnappingPositions.isEmpty {
                            snapScrollPosition(in: store.uiScrollView, params: params)
                        }
                    },
                    onReachBottom: {
                        params.didReachBottom?()
                    },
                    onPullToRefresh: triggerRefresh,
                    onPullToLoadMore: triggerLoadMore,
                    onDragProgress: onDragProgress
                ) {
                    content
                }
            },
            params: params,
            headerHeight: currentHeaderHeight,
            scrollOffset: store.currentRawOffset,
            scrollViewProvider: { store.uiScrollView }
        )
        .onChange(of: params.scrollToTop.wrappedValue) { value in
            if value {
                params.scrollToTop.wrappedValue = false
                setScrollPositionTo(.expanded)
            }
        }
        .onChange(of: params.shouldSnapTo.wrappedValue) { value in
            if let value {
                params.shouldSnapTo.wrappedValue = nil
                setScrollPositionTo(value)
            }
        }
    }

    // MARK: - Private helpers

    private func setScrollPositionTo(_ state: SnapHeaderState) {
        switch state {
        case .expanded:
            store.uiScrollView?.setContentOffset(CGPoint(x: 0, y: -params.maxHeight), animated: true)
        case .collapsed:
            store.uiScrollView?.setContentOffset(CGPoint(x: 0, y: -params.minHeight), animated: true)
        case .custom(let value):
            store.uiScrollView?.setContentOffset(CGPoint(x: 0, y: -params.minHeight + value), animated: true)
        }
    }
}
