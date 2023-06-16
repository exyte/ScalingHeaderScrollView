//
//  ScalingHeaderScrollView.swift
//  ScalingHeaderScrollView
//
//  Created by Alisa Mylnikova on 16/09/2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import SwiftUI
import Introspect

public struct ScalingHeaderScrollView<Header: View, Content: View>: View {
    
    /// Content on the top, which will be collapsed
    public var header: Header

    /// Content on the bottom
    public var content: Content
    
    /// Should the progress view be showing or not
    @State private var isSpinning: Bool = false
    
    /// UIKit's UIScrollView
    @State private var uiScrollView: UIScrollView?
    
    /// UIScrollView delegate, needed for calling didPullToRefresh or didEndDragging
    @StateObject private var scrollViewDelegate = ScalingHeaderScrollViewDelegate()

    /// ScrollView's header frame, needed for calculation of frame changing
//    @StateObject private var headerFrame = ViewFrame()

    /// ScrollView's content frame, needed for calculation of frame changing
    @StateObject private var contentFrame = ViewFrame()

    /// Interpolation from 0 to 1 of current collapse progress
    @Binding private var progress: CGFloat
    
    /// Current scroll offset Y value
    @Binding private var scrollOffset: CGFloat

    /// Automatically sets to true, if pull to refresh is triggered. Manually set to false to hide loading indicator.
    @Binding private var isLoading: Bool

    /// Set to true to immediately scroll to top
    @Binding private var scrollToTop: Bool

    /// Called once pull to refresh is triggered
    private var didPullToRefresh: (() -> Void)?

    /// Height for uncollapsed state
    private var maxHeight: CGFloat = 350.0

    /// Height for collapsed state
    private var minHeight: CGFloat = 150.0

    /// Allow collapsing while scrolling up
    private var allowsHeaderCollapseFlag: Bool = false

    /// Allow enlarging while pulling down
    private var allowsHeaderGrowthFlag: Bool = false
    
    /// Shows or hides the indicator for the scrollView
    private var showsIndicators: Bool = true

    /// Allow force snap to closest position after lifting the finger, i.e. forbid to be left in unfinished state
    /// Specify any amount of values in 0...1 to set snapping points, 0 - fully collapsed header, 1 - fully expanded
    private var headerSnappingPositions: [CGFloat] = []

    /// Use this to set initial scroll position to anything other than fully expanded
    /// Set a value in 0...1, 0 - fully collapsed header, 1 - fully expanded
    private var initialSnapPosition: CGFloat?
    
    /// Clipped or not header
    private var headerIsClipped: Bool = true
    
    /// Private computed properties

    private var hasPullToRefresh: Bool {
        didPullToRefresh != nil
    }
    
    private var contentOffset: CGFloat {
        isLoading && hasPullToRefresh ? maxHeight + 32.0 : maxHeight
    }
    
    private var progressViewOffset: CGFloat {
        isLoading ? maxHeight + 24.0 : maxHeight
    }

    /// height for header: reduced if reducing is allowed, or fixed if not
    private var headerHeight: CGFloat {
        allowsHeaderCollapseFlag ? getHeightForHeaderView() : maxHeight
    }

    /// Scaling for header: to enlarge while pulling down
    private var headerScaleOnPullDown: CGFloat {
        !hasPullToRefresh && allowsHeaderGrowthFlag ? max(1.0, getHeightForHeaderView() / maxHeight * 0.9) : 1.0
    }
    
    private var needToShowProgressView: Bool {
        hasPullToRefresh && (isLoading || isSpinning)
    }
    
    // MARK: - Init
    
    public init(@ViewBuilder header: @escaping () -> Header, @ViewBuilder content: @escaping () -> Content) {
        self.header = header()
        self.content = content()
        _progress = .constant(0)
        _scrollOffset = .constant(0)
        _isLoading = .constant(false)
        _scrollToTop = .constant(false)
    }
    
    // MARK: - Body builder
    
    public var body: some View {
        GeometryReader { globalGeometry in
            ScrollView(showsIndicators: showsIndicators) {
                content
                    .offset(y: contentOffset)
                    .frameGetter($contentFrame.frame)
                    .onChange(of: contentFrame.frame) { frame in
                        isSpinning = frame.minY - globalGeometry.frame(in: .global).minY > 20.0
                    }
                    .onChange(of: scrollToTop) { value in
                        if value {
                            scrollToTop = false
                            setScrollPositionToTop()
                        }
                    }

                GeometryReader { scrollGeometry in
                    ZStack(alignment: .topLeading) {
                        if needToShowProgressView {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .frame(width: UIScreen.main.bounds.width, height: getHeightForLoadingView())
                                .scaleEffect(1.25)
                                .offset(y: getOffsetForHeader() + progressViewOffset)
                        }

                        header
                            .frame(height: headerHeight)
                            .clipped(isClipped: headerIsClipped)
                            .offset(y: getOffsetForHeader())
                            .allowsHitTesting(true)
                            .scaleEffect(headerScaleOnPullDown)
                    }
                    .offset(y: getGeometryReaderVsScrollView(scrollGeometry: scrollGeometry, globalGeometry: globalGeometry))
                }
                .background(Color.clear)
                .frame(height: maxHeight)
                .offset(y: -(contentFrame.startingRect?.maxY ?? UIScreen.main.bounds.height))
            }
            .introspectScrollView { scrollView in
                configure(scrollView: scrollView)
            }
            .onAppear {
                snapInitialScrollPosition()
            }
        }
    }
    
    // MARK: - Private configure
    
    private func configure(scrollView: UIScrollView) {
        scrollView.delegate = scrollViewDelegate
        if let didPullToRefresh = didPullToRefresh {
            scrollViewDelegate.didPullToRefresh = {
                withAnimation { isLoading = true }
                didPullToRefresh()
            }
        }
        scrollViewDelegate.didScroll = {
            DispatchQueue.main.async {
                self.progress = getCollapseProgress()
                self.scrollOffset = -getScrollOffset()
            }
        }
        scrollViewDelegate.didEndDragging = {
            isSpinning = false
            if !headerSnappingPositions.isEmpty {
                snapScrollPosition()
            }
        }
        DispatchQueue.main.async {
            if uiScrollView != scrollView {
                uiScrollView = scrollView
                snapInitialScrollPosition()
            }
        }
    }
    
    // MARK: - Private actions
    
    private func setScrollPositionToTop() {
        guard var contentOffset = uiScrollView?.contentOffset, contentOffset.y > 0 else { return }
        contentOffset.y = maxHeight - minHeight
        uiScrollView?.setContentOffset(contentOffset, animated: true)
    }
    
    private func snapScrollPosition() {
        guard var contentOffset = uiScrollView?.contentOffset else { return }

        let extraSpace: CGFloat = maxHeight - minHeight
        let offset = contentOffset.y
        for i in 0..<headerSnappingPositions.count - 1 {
            let first = headerSnappingPositions[i] * extraSpace
            let second = headerSnappingPositions[i+1] * extraSpace
            if offset > first, offset < second {
                let result: CGFloat
                if (offset - first) < (second - offset) { // closer to first point
                    result = first
                } else {
                    result = second
                }
                contentOffset.y = result
                uiScrollView?.setContentOffset(contentOffset, animated: true)
                return
            }
        }
    }

    private func snapInitialScrollPosition() {
        if let initialSnapPosition = initialSnapPosition {
            guard var contentOffset = uiScrollView?.contentOffset else { return }
            let extraSpace: CGFloat = maxHeight - minHeight
            contentOffset.y = initialSnapPosition * extraSpace
            uiScrollView?.setContentOffset(contentOffset, animated: true)
        }
    }
    
    // MARK: - Private getters for heights and offsets
    
    private func getScrollOffset() -> CGFloat {
        -(uiScrollView?.contentOffset.y ?? 0)
    }
    
    private func getGeometryReaderVsScrollView(scrollGeometry: GeometryProxy, globalGeometry: GeometryProxy) -> CGFloat {
        getScrollOffset() - scrollGeometry.frame(in: .global).minY + globalGeometry.frame(in: .global).minY
    }
    
    private func getOffsetForHeader() -> CGFloat {
        let offset = getScrollOffset()
        let extraSpace = maxHeight - minHeight
        
        if offset < -extraSpace {
            let imageOffset = abs(min(-extraSpace, offset))
            return allowsHeaderCollapseFlag ? imageOffset : (minHeight - maxHeight) - offset
        } else if offset > 0 {
            return -offset
        }
        return maxHeight - headerHeight
    }
    
    private func getHeightForHeaderView() -> CGFloat {
        let offset = getScrollOffset()
        if hasPullToRefresh {
            return min(max(minHeight, maxHeight + offset), maxHeight)
        } else {
            return max(minHeight, maxHeight + offset)
        }
    }
    
    private func getCollapseProgress() -> CGFloat {
        1 - min(max((getHeightForHeaderView() - minHeight) / (maxHeight - minHeight), 0), 1)
    }
    
    private func getHeightForLoadingView() -> CGFloat {
        max(0, getScrollOffset())
    }
}

// MARK: - Extension View

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

// MARK: - Modifiers 

extension ScalingHeaderScrollView {

    /// Passes current collapse progress value into progress binding
    public func collapseProgress(_ progress: Binding<CGFloat>) -> ScalingHeaderScrollView {
        var scalingHeaderScrollView = self
        scalingHeaderScrollView._progress = progress
        return scalingHeaderScrollView
    }
    
    /// Passes current scroll offset value into binding
    public func scrollOffset(_ scrollOffset: Binding<CGFloat>) -> ScalingHeaderScrollView {
        var scalingHeaderScrollView = self
        scalingHeaderScrollView._scrollOffset = scrollOffset
        return scalingHeaderScrollView
    }
    
    /// Allows to set up callback and `isLoading` state for pull-to-refresh action
    public func pullToRefresh(isLoading: Binding<Bool>, perform: @escaping () -> Void) -> ScalingHeaderScrollView {
        var scalingHeaderScrollView = self
        scalingHeaderScrollView._isLoading = isLoading
        scalingHeaderScrollView.didPullToRefresh = perform
        return scalingHeaderScrollView
    }
    
    /// Allows content scroll reset, need to change Binding to `true`
    public func scrollToTop(resetScroll: Binding<Bool>) -> ScalingHeaderScrollView {
        var scalingHeaderScrollView = self
        scalingHeaderScrollView._scrollToTop = resetScroll
        return scalingHeaderScrollView
    }
    
    /// Changes min and max heights of Header
    public func height(min: CGFloat = 150.0, max: CGFloat = 350.0) -> ScalingHeaderScrollView {
        var scalingHeaderScrollView = self
        scalingHeaderScrollView.minHeight = min
        scalingHeaderScrollView.maxHeight = max
        return scalingHeaderScrollView
    }
    
    /// When scrolling up - switch between actual header collapse and simply moving it up
    public func allowsHeaderCollapse(_ allows: Bool = true) -> ScalingHeaderScrollView {
        var scalingHeaderScrollView = self
        scalingHeaderScrollView.allowsHeaderCollapseFlag = allows
        return scalingHeaderScrollView
    }

    /// When scrolling down - enable/disable header scale
    public func allowsHeaderGrowth(_ allows: Bool = true) -> ScalingHeaderScrollView {
        var scalingHeaderScrollView = self
        scalingHeaderScrollView.allowsHeaderGrowthFlag = allows
        return scalingHeaderScrollView
    }

    /// Enable/disable header snap (once you lift your finger header snaps either to min or max height automatically)
    public func allowsHeaderSnap() -> ScalingHeaderScrollView {
        var scalingHeaderScrollView = self
        scalingHeaderScrollView.headerSnappingPositions = [0, 1]
        return scalingHeaderScrollView
    }
    
    /// Set positions for header snap (once you lift your finger header snaps to closest allowed position)
    public func headerSnappingPositions(snapPositions: [CGFloat]) -> ScalingHeaderScrollView {
        var scalingHeaderScrollView = self
        scalingHeaderScrollView.headerSnappingPositions = snapPositions
        return scalingHeaderScrollView
    }

    /// Use this to set initial scroll position to anything other than fully expanded
    public func initialSnapPosition(initialSnapPosition: CGFloat) -> ScalingHeaderScrollView {
        var scalingHeaderScrollView = self
        scalingHeaderScrollView.initialSnapPosition = initialSnapPosition
        return scalingHeaderScrollView
    }
    
    /// Hiddes scroll indicators
    public func hideScrollIndicators(_ hide: Bool = false) -> ScalingHeaderScrollView {
        var scalingHeaderScrollView = self
        scalingHeaderScrollView.showsIndicators = hide
        return scalingHeaderScrollView
    }
    
    /// Header clipped
    public func headerIsClipped(_ isClipped: Bool = true) -> ScalingHeaderScrollView {
        var scalingHeaderScrollView = self
        scalingHeaderScrollView.headerIsClipped = isClipped
        return scalingHeaderScrollView
    }
}
