//
//  ScalingHeaderCore.swift
//  ScalingHeaderScrollView
//

import SwiftUI
import UIKit

struct ScalingHeaderCore<Header: View, Content: View>: View {

    var header: (CGFloat, CGFloat) -> Header
    var contentBuilder: (
        _ triggerRefresh: (() -> Void)?,
        _ triggerLoadMore: (() -> Void)?,
        _ onDragProgress: ((CGFloat, CGFloat) -> Void)?
    ) -> Content

    var params: ScalingHeaderParameters
    var headerHeight: CGFloat
    var scrollOffset: CGFloat
    var scrollViewProvider: (() -> UIScrollView?)? = nil

    @State private var isLoading = false
    @State private var pullToRefreshInProgress = false
    @State private var pullToLoadMoreInProgress = false
    @State private var refreshDragProgress: CGFloat = 0
    @State private var loadMoreDragProgress: CGFloat = 0
    @State private var refreshSpinnerOpacity: CGFloat = 1

    private var hasPullToRefresh: Bool { params.isPullToRefreshEnabled && params.didPullToRefresh != nil }
    private var hasPullToLoadMore: Bool { params.isPullToLoadMoreEnabled && params.didPullToLoadMore != nil }
    private var showRefreshSpinner: Bool { hasPullToRefresh && isLoading && pullToRefreshInProgress }
    private var showLoadMoreSpinner: Bool { hasPullToLoadMore && isLoading && pullToLoadMoreInProgress }

    private var collapseProgressValue: CGFloat {
        max(0, min(1, (params.maxHeight - headerHeight) / (params.maxHeight - params.minHeight)))
    }

    var body: some View {
        ZStack(alignment: .top) {
            contentBuilder(
                hasPullToRefresh ? { triggerPullToRefresh() } : nil,
                hasPullToLoadMore ? { triggerPullToLoadMore() } : nil,
                hasPullToRefresh || hasPullToLoadMore ? { refresh, loadMore in
                    DispatchQueue.main.async {
                        if !pullToRefreshInProgress { refreshDragProgress = refresh }
                        if !pullToLoadMoreInProgress { loadMoreDragProgress = loadMore }
                    }
                } : nil
            )
            .ignoresSafeArea()

            if hasPullToRefresh {
                PetalSpinner(progress: refreshDragProgress, isSpinning: showRefreshSpinner)
                    .frame(maxWidth: .infinity)
                    .offset(y: headerHeight + 8)
                    .opacity(refreshSpinnerOpacity)
            }

            if hasPullToLoadMore {
                VStack {
                    Spacer()
                    PetalSpinner(progress: loadMoreDragProgress, isSpinning: showLoadMoreSpinner)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 16)
                }
            }

            if params.showsIndicators {
                customScrollIndicator
            }

            Color.clear
                .frame(height: headerHeight)
                .frame(maxWidth: .infinity)
                .overlay(alignment: params.headerAlignment) {
                    header(headerHeight, collapseProgressValue)
                }
                .clipped(isClipped: params.headerIsClipped)
                .animation(params.headerAnimation, value: params.shouldSnapTo.wrappedValue)
        }
        .ignoresSafeArea()
        .onChange(of: headerHeight) { _ in
            params.collapseProgress.wrappedValue = collapseProgressValue
        }
    }

    // has to be custom because the standard one goes under header's overlay,
    // and with arbirary content height there is not way to make it look right
    var customScrollIndicator: some View {
        GeometryReader { geo in
            let sv = scrollViewProvider?()
            let contentH = sv?.contentSize.height ?? 0
            let screenH = geo.size.height
            let bottomInset = sv?.safeAreaInsets.bottom ?? 0
            let trackH = screenH - params.minHeight - bottomInset
            let visibleH = screenH - params.minHeight
            let scrollable = contentH - visibleH
            let isVisible = scrollOffset > -params.minHeight && scrollable > 0

            if isVisible {
                let progress = max(0, min(1, (scrollOffset + params.minHeight) / max(1, scrollable)))
                let thumbH = max(44, trackH * min(1, visibleH / max(1, contentH)))
                let thumbTop = params.minHeight + progress * (trackH - thumbH)

                RoundedRectangle(cornerRadius: 1.5)
                    .fill(Color(UIColor.label).opacity(0.35))
                    .frame(width: 2.5, height: thumbH)
                    .position(x: geo.size.width - 4, y: thumbTop + thumbH / 2)
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }

    private func triggerPullToRefresh() {
        guard let action = params.didPullToRefresh else { return }
        Task { @MainActor in
            pullToLoadMoreInProgress = false
            pullToRefreshInProgress = true
            withAnimation { isLoading = true }
            let sv = scrollViewProvider?()
            await action()
            withAnimation(.easeOut(duration: 0.3)) { refreshSpinnerOpacity = 0 }
            UIView.animate(withDuration: 0.3) {
                sv?.contentInset.top = params.maxHeight
                sv?.contentOffset = CGPoint(x: 0, y: -params.maxHeight)
            }
            try? await Task.sleep(nanoseconds: 300_000_000)
            isLoading = false
            pullToRefreshInProgress = false
            refreshDragProgress = 0
            refreshSpinnerOpacity = 1
        }
    }

    private func triggerPullToLoadMore() {
        guard let action = params.didPullToLoadMore else { return }
        Task { @MainActor in
            pullToLoadMoreInProgress = true
            pullToRefreshInProgress = false
            withAnimation { isLoading = true }
            let sv = scrollViewProvider?()
            sv?.contentInset.bottom = 60
            await action()
            UIView.animate(withDuration: 0.3) {
                sv?.contentInset.bottom = 0
            }
            isLoading = false
            pullToLoadMoreInProgress = false
            withAnimation(.easeOut(duration: 0.3)) { loadMoreDragProgress = 0 }
        }
    }
}
