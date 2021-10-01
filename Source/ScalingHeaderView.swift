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
    
    /// Required fields
    @ViewBuilder public var header: (CGFloat) -> Header
    @ViewBuilder public var content: Content
    
    @Binding public var isLoading: Bool
    public var didPullToRefresh: (() -> Void)?
    
    @Binding public var scrollToTop: Bool
    
    @State private var isSpinning: Bool = false
    @State private var uiScrollView: UIScrollView?
    @StateObject private var scrollViewDelegate = ScalingHeaderScrollViewDelegate()
    @StateObject private var contentFrame = ViewFrame()
    
    private var maxHeight: CGFloat = 350.0
    private var minHeight: CGFloat = 150.0
    private var noHeaderCollapse: Bool = false
    private var noSnapping: Bool = false
    private var noHeaderScale: Bool = false
    
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
        noRefresh && !noHeaderScale ? max(1.0, getHeightForHeaderView() / maxHeight * 0.9) : 1.0
    }
    
    private var needToShowProgressView: Bool {
        !noRefresh && (isLoading || isSpinning)
    }
    
    public init(header: @escaping (CGFloat) -> Header, @ViewBuilder content: @escaping () -> Content) {
        self.header = header
        self.content = content()
        _isLoading = .constant(false)
        _scrollToTop = .constant(false)
    }
    
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
        guard !noSnapping else { return }
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
            return noHeaderCollapse ? (minHeight - maxHeight) - offset : imageOffset
        } else if offset > 0 {
            return -offset
        }
        return maxHeight - getHeightForHeaderView()
    }
    
    private func getHeightForHeaderView() -> CGFloat {
        guard !noHeaderCollapse else {
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
    
    public func pullToRefresh(isLoading: Binding<Bool>, perform: @escaping () -> Void) -> ScalingHeaderScrollView {
        var scalingHeaderScrollView = self
        scalingHeaderScrollView._isLoading = isLoading
        scalingHeaderScrollView.didPullToRefresh = perform
        return scalingHeaderScrollView
    }
    
    public func scrollToTop(immediately: Binding<Bool>) -> ScalingHeaderScrollView {
        var scalingHeaderScrollView = self
        scalingHeaderScrollView._scrollToTop = immediately
        return scalingHeaderScrollView
    }
    
    public func height(min: CGFloat = 150.0, max: CGFloat = 350.0) -> ScalingHeaderScrollView {
        var scalingHeaderScrollView = self
        scalingHeaderScrollView.minHeight = min
        scalingHeaderScrollView.maxHeight = max
        return scalingHeaderScrollView
    }
    
    public func disableHeaderCollapse() -> ScalingHeaderScrollView {
        var scalingHeaderScrollView = self
        scalingHeaderScrollView.noHeaderCollapse = true
        return scalingHeaderScrollView
    }
    
    public func disableHeaderSnap() -> ScalingHeaderScrollView {
        var scalingHeaderScrollView = self
        scalingHeaderScrollView.noSnapping = true
        return scalingHeaderScrollView
    }
    
    public func disableHeaderScale() -> ScalingHeaderScrollView {
        var scalingHeaderScrollView = self
        scalingHeaderScrollView.noHeaderScale = true
        return scalingHeaderScrollView
    }
}
