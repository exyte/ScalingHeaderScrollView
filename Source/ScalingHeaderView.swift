//
//  ScalingHeaderView.swift
//  ScalingHeaderView
//
//  Created by Alisa Mylnikova on 16/09/2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import SwiftUI
import Introspect

public struct ScalingHeaderScrollView<Header: View, Content: View>: View {
    
    /// Public required properties, header and content should be pass to init
    @ViewBuilder public var header: (CGFloat) -> Header
    @ViewBuilder public var content: Content
    
    /// should be showing or not a progress view
    @State private var isSpinning: Bool = false
    
    /// UIKit's UIScrollView
    @State private var uiScrollView: UIScrollView?
    
    /// UIScrollView delegate, needed for calling didPullToRefresh or didEndDragging
    @StateObject private var scrollViewDelegate = ScalingHeaderScrollViewDelegate()
    
    /// ScrollView's content frame, needed for calculation of frame changing
    @StateObject private var contentFrame = ViewFrame()
    
    /// Private properties for modifiers, see descriptions in `Modifiers`  section
    @Binding private var scrollToTop: Bool
    @Binding private var isLoading: Bool
    private var didPullToRefresh: (() -> Void)?
    private var maxHeight: CGFloat = 350.0
    private var minHeight: CGFloat = 150.0
    private var allowsHeaderCollapse: Bool = true
    private var allowHeaderSnap: Bool = true
    private var allowHeaderScale: Bool = true
    
    /// Private computed properties
    private var noRefresh: Bool {
        didPullToRefresh == nil
    }
    
    private var contentOffset: CGFloat {
        isLoading && !noRefresh ? maxHeight + 32.0 : maxHeight
    }
    
    private var progressViewOffset: CGFloat {
        isLoading ? maxHeight + 24.0 : maxHeight
    }
    
    private var headerScale: CGFloat {
        noRefresh && allowHeaderScale ? max(1.0, getHeightForHeaderView() / maxHeight * 0.9) : 1.0
    }
    
    private var needToShowProgressView: Bool {
        !noRefresh && (isLoading || isSpinning)
    }
    
    // MARK: - Init
    
    public init(header: @escaping (CGFloat) -> Header, @ViewBuilder content: @escaping () -> Content) {
        self.header = header
        self.content = content()
        _isLoading = .constant(false)
        _scrollToTop = .constant(false)
    }
    
    // MARK: - Body builder
    
    public var body: some View {
        ScrollView {
            content
                .offset(y: contentOffset)
                .background(GeometryGetter(rect: $contentFrame.frame))
                .onChange(of: contentFrame.frame) { frame in
                    isSpinning = frame.minY > 20.0
                }
                .onChange(of: scrollToTop) { _ in
                    scrollToTopContent()
                }
            
            GeometryReader { geometry in
                ZStack(alignment: .topLeading) {
                    if needToShowProgressView {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .frame(width: UIScreen.main.bounds.width, height: getHeightForLoadingView())
                            .scaleEffect(1.25)
                            .offset(x: 0, y: getOffsetForHeader() + progressViewOffset)
                    }
                    
                    header(getCollapseProgress())
                        .frame(height: getHeightForHeaderView())
                        .clipped()
                        .offset(x: 0, y: getOffsetForHeader())
                        .allowsHitTesting(true)
                        .scaleEffect(headerScale)
                }
                .offset(x: 0, y: getGeometryReaderVsScrollView(geometry))
            }
            .background(Color.clear)
            .frame(height: maxHeight)
            .offset(x: 0, y: -(contentFrame.startingRect?.maxY ?? UIScreen.main.bounds.height))
        }
        .introspectScrollView { scrollView in
            configure(scrollView: scrollView)
        }
        .ignoresSafeArea(.all)
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
        scrollViewDelegate.didEndDragging = { _ in
            isSpinning = false
            snapping()
        }
        uiScrollView = scrollView
    }
    
    // MARK: - Private actions
    
    private func scrollToTopContent() {
        guard scrollToTop else { return }
        scrollToTop = false
        guard var contentOffset = uiScrollView?.contentOffset, contentOffset.y > 0 else { return }
        contentOffset.y = maxHeight - minHeight
        uiScrollView?.setContentOffset(contentOffset, animated: true)
    }
    
    private func snapping() {
        guard allowHeaderSnap else { return }
        guard var contentOffset = uiScrollView?.contentOffset else { return }
        let extraSpace: CGFloat = maxHeight - minHeight
        contentOffset.y = contentOffset.y < extraSpace / 2 ? 0 : max(extraSpace, contentOffset.y)
        uiScrollView?.setContentOffset(contentOffset, animated: true)
    }
    
    // MARK: - Private getters for heights and offsets
    
    private func getScrollOffset() -> CGFloat {
        -(uiScrollView?.contentOffset.y ?? 0)
    }
    
    private func getGeometryReaderVsScrollView(_ geometry: GeometryProxy) -> CGFloat {
        getScrollOffset() - geometry.frame(in: .global).minY
    }
    
    private func getOffsetForHeader() -> CGFloat {
        let offset = getScrollOffset()
        let extraSpace = maxHeight - minHeight
        
        if offset < -extraSpace {
            let imageOffset = abs(min(-extraSpace, offset))
            return allowsHeaderCollapse ? imageOffset : (minHeight - maxHeight) - offset
        } else if offset > 0 {
            return -offset
        }
        return maxHeight - getHeightForHeaderView()
    }
    
    private func getHeightForHeaderView() -> CGFloat {
        guard allowsHeaderCollapse else {
            return maxHeight
        }
        let offset = getScrollOffset()
        if noRefresh {
            return max(minHeight, maxHeight + offset)
        } else {
            return min(max(minHeight, maxHeight + offset), maxHeight)
        }
    }
    
    private func getCollapseProgress() -> CGFloat {
        1 - min(max((getHeightForHeaderView() - minHeight) / (maxHeight - minHeight), 0), 1)
    }
    
    private func getHeightForLoadingView() -> CGFloat {
        max(0, getScrollOffset())
    }
}

// MARK: - Modifiers 

extension ScalingHeaderScrollView {
    
    /// allows set up callback and `isLoading` state for pull-to-refresh action
    public func pullToRefresh(isLoading: Binding<Bool>, perform: @escaping () -> Void) -> ScalingHeaderScrollView {
        var scalingHeaderScrollView = self
        scalingHeaderScrollView._isLoading = isLoading
        scalingHeaderScrollView.didPullToRefresh = perform
        return scalingHeaderScrollView
    }
    
    /// allows scrolling to top content, need to change Binding to `true`
    public func scrollToTop(immediately: Binding<Bool>) -> ScalingHeaderScrollView {
        var scalingHeaderScrollView = self
        scalingHeaderScrollView._scrollToTop = immediately
        return scalingHeaderScrollView
    }
    
    /// changes min and max heights of Header, default `min = 150.0` and `max = 350.0`
    public func height(min: CGFloat = 150.0, max: CGFloat = 350.0) -> ScalingHeaderScrollView {
        var scalingHeaderScrollView = self
        scalingHeaderScrollView.minHeight = min
        scalingHeaderScrollView.maxHeight = max
        return scalingHeaderScrollView
    }
    
    /// allows enabling/disabling ability of header collapse
    public func allowsHeaderCollapse(_ value: Bool) -> ScalingHeaderScrollView {
        var scalingHeaderScrollView = self
        scalingHeaderScrollView.allowsHeaderCollapse = value
        return scalingHeaderScrollView
    }
    
    /// allows enabling/disabling ability of header snap
    public func allowHeaderSnap(_ value: Bool) -> ScalingHeaderScrollView {
        var scalingHeaderScrollView = self
        scalingHeaderScrollView.allowHeaderSnap = true
        return scalingHeaderScrollView
    }
    
    /// allows enabling/disabling ability of header scale
    public func allowHeaderScale(_ value: Bool) -> ScalingHeaderScrollView {
        var scalingHeaderScrollView = self
        scalingHeaderScrollView.allowHeaderScale = true
        return scalingHeaderScrollView
    }
}
