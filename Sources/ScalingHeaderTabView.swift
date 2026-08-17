//
//  ScalingHeaderTabView.swift
//  ScalingHeaderScrollView
//

import SwiftUI
import UIKit

public struct ScalingHeaderTabView<Tab: Hashable & CaseIterable, Header: View, Content: View>: ScalingHeaderViewAPI {

    @Binding var selection: Tab
    var header: (CGFloat, CGFloat) -> Header
    var pageContent: (Tab) -> Content

    public var params: ScalingHeaderParameters

    @State private var headerHeight: CGFloat
    @State private var scrollOffset: CGFloat
    @State private var tabStates = TabScrollStates<Tab>()
    @State private var acceleration: CGFloat = 0

    public init(
        selection: Binding<Tab>,
        minHeight: CGFloat = 150,
        maxHeight: CGFloat = 350,
        @ViewBuilder header: @escaping (CGFloat, CGFloat) -> Header,
        @ViewBuilder pageContent: @escaping (Tab) -> Content
    ) {
        self._selection = selection
        self.params = ScalingHeaderParameters(minHeight: minHeight, maxHeight: maxHeight, headerAlignment: .bottom)
        self.header = header
        self.pageContent = pageContent
        self._headerHeight = State(initialValue: maxHeight)
        self._scrollOffset = State(initialValue: -maxHeight)
    }

    public var body: some View {
        ScalingHeaderCore(
            header: header,
            contentBuilder: { triggerRefresh, triggerLoadMore, onDragProgress in
                tabPages(
                    triggerRefresh: triggerRefresh,
                    triggerLoadMore: triggerLoadMore,
                    onDragProgress: onDragProgress
                )
            },
            params: params,
            headerHeight: headerHeight,
            scrollOffset: scrollOffset,
            scrollViewProvider: { tabStates.states[selection]?.scrollView }
        )
        .onChange(of: selection) { newTab in
            guard let sv = tabStates.states[newTab]?.scrollView else { return }

            guard params.allowsHeaderCollapseFlag else {
                headerHeight = params.maxHeight
                sv.setContentOffset(CGPoint(x: 0, y: -params.maxHeight), animated: false)
                return
            }

            let savedOffset = tabStates.states[newTab]?.offset ?? -params.maxHeight
            let contentScroll = max(0, savedOffset + params.minHeight)

            if contentScroll > 0 {
                headerHeight = params.minHeight
                sv.setContentOffset(CGPoint(x: 0, y: -params.minHeight + contentScroll), animated: false)
            } else {
                sv.setContentOffset(CGPoint(x: 0, y: -headerHeight), animated: false)
            }
        }
        .onChange(of: params.scrollToTop.wrappedValue) { value in
            guard value else { return }
            params.scrollToTop.wrappedValue = false
            tabStates.states[selection]?.scrollView?.setContentOffset(
                CGPoint(x: 0, y: -params.maxHeight),
                animated: true
            )
        }
        .onChange(of: params.shouldSnapTo.wrappedValue) { value in
            guard let value else { return }
            params.shouldSnapTo.wrappedValue = nil
            guard let sv = tabStates.states[selection]?.scrollView else { return }
            switch value {
            case .expanded:
                sv.setContentOffset(CGPoint(x: 0, y: -params.maxHeight), animated: true)
            case .collapsed:
                sv.setContentOffset(CGPoint(x: 0, y: -params.minHeight), animated: true)
            case .custom(let offset):
                sv.setContentOffset(CGPoint(x: 0, y: -params.minHeight + offset), animated: true)
            }
        }
    }

    // MARK: - Private

    private var initialHeaderOffset: CGFloat {
        guard let pos = params.initialSnapPosition else { return -params.maxHeight }
        return -params.maxHeight + pos * (params.maxHeight - params.minHeight)
    }

    private func tabPages(
        triggerRefresh: (() -> Void)?,
        triggerLoadMore: (() -> Void)?,
        onDragProgress: ((CGFloat, CGFloat) -> Void)?
    ) -> some View {
        TabView(selection: $selection) {
            ForEach(Array(Tab.allCases), id: \.self) { tab in
                PageScrollView(
                    topInset: params.maxHeight,
                    minInset: params.minHeight,
                    initialOffset: initialHeaderOffset,
                    onScrollViewReady: { sv in
                        tabStates.states[tab, default: TabScrollState()].scrollView = sv
                    },
                    onOffsetChange: { offset, isUserInitiated in
                        tabStates.states[tab, default: TabScrollState()].offset = offset
                        guard selection == tab else { return }

                        let newHeight: CGFloat
                        if !params.allowsHeaderCollapseFlag {
                            newHeight = params.maxHeight
                        } else if params.allowsHeaderGrowthFlag {
                            newHeight = max(params.minHeight, -offset)
                        } else {
                            newHeight = max(params.minHeight, min(params.maxHeight, -offset))
                        }

                        // System-initiated events (programmatic setContentOffset, layout
                        // adjustments) must not expand the header beyond its preserved height.
                        guard isUserInitiated || newHeight <= headerHeight else { return }

                        headerHeight = newHeight
                        scrollOffset = offset
                        params.scrollOffset.wrappedValue = offset
                    },
                    onDidInitialize: { sv in
                        // For lazily-created tabs that become selected before their VC exists,
                        // onChange couldn't set the offset. Correct it here after layout.
                        guard selection == tab else { return }
                        sv.setContentOffset(CGPoint(x: 0, y: -headerHeight), animated: false)
                    },
                    onWillEndDragging: tab == selection ? { velocity in acceleration = velocity } : nil,
                    onEndDragging: tab == selection ? {
                        guard !params.headerSnappingPositions.isEmpty else { return }
                        if !params.headerSnappingShouldWaitFinishAccelerating || abs(acceleration) < 0.2 {
                            snapScrollPosition(in: tabStates.states[selection]?.scrollView, params: params)
                        }
                    } : nil,
                    onEndDecelerating: tab == selection ? {
                        if params.headerSnappingShouldWaitFinishAccelerating && !params.headerSnappingPositions.isEmpty {
                            snapScrollPosition(in: tabStates.states[selection]?.scrollView, params: params)
                        }
                    } : nil,
                    onReachBottom: tab == selection ? { params.didReachBottom?() } : nil,
                    onPullToRefresh: tab == selection ? triggerRefresh : nil,
                    onPullToLoadMore: tab == selection ? triggerLoadMore : nil,
                    onDragProgress: tab == selection ? onDragProgress : nil
                ) {
                    pageContent(tab)
                }
                .ignoresSafeArea()
                .tag(tab)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}
