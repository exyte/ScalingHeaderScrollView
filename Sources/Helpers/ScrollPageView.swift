//
//  PageScrollView.swift
//  ScalingHeaderScrollView
//

import SwiftUI
import UIKit

struct PageScrollView<Content: View>: UIViewControllerRepresentable {

    var topInset: CGFloat
    var minInset: CGFloat
    var initialOffset: CGFloat
    var onScrollViewReady: (UIScrollView) -> Void = { _ in }
    var onOffsetChange: (CGFloat, Bool) -> Void
    var onDidInitialize: ((UIScrollView) -> Void)? = nil
    var onWillEndDragging: ((CGFloat) -> Void)? = nil
    var onEndDragging: (() -> Void)? = nil
    var onEndDecelerating: (() -> Void)? = nil
    var onReachBottom: (() -> Void)? = nil
    var onPullToRefresh: (() -> Void)? = nil
    var onPullToLoadMore: (() -> Void)? = nil
    var onDragProgress: ((CGFloat, CGFloat) -> Void)? = nil
    var content: () -> Content

    func makeUIViewController(context: Context) -> PageViewController<Content> {
        let vc = PageViewController(topInset: topInset, minInset: minInset, initialOffset: initialOffset, content: content())
        vc.onScrollViewReady = onScrollViewReady
        configure(vc)
        return vc
    }

    func updateUIViewController(_ vc: PageViewController<Content>, context: Context) {
        vc.hostingController.rootView = content()
        configure(vc)
    }

    private func configure(_ vc: PageViewController<Content>) {
        vc.onOffsetChange = onOffsetChange
        vc.onDidInitialize = onDidInitialize
        vc.onWillEndDragging = onWillEndDragging
        vc.onEndDragging = onEndDragging
        vc.onEndDecelerating = onEndDecelerating
        vc.onReachBottom = onReachBottom
        vc.onPullToRefresh = onPullToRefresh
        vc.onPullToLoadMore = onPullToLoadMore
        vc.onDragProgress = onDragProgress
    }
}

// MARK: -

final class PageViewController<Content: View>: UIViewController, UIScrollViewDelegate {

    let scrollView = UIScrollView()
    let hostingController: UIHostingController<Content>

    var onScrollViewReady: ((UIScrollView) -> Void)?
    var onOffsetChange: ((CGFloat, Bool) -> Void)?
    var onDidInitialize: ((UIScrollView) -> Void)?
    var onWillEndDragging: ((CGFloat) -> Void)?
    var onEndDragging: (() -> Void)?
    var onEndDecelerating: (() -> Void)?
    var onReachBottom: (() -> Void)?
    var onPullToRefresh: (() -> Void)?
    var onPullToLoadMore: (() -> Void)?
    var onDragProgress: ((CGFloat, CGFloat) -> Void)?

    private let topInset: CGFloat
    private let minInset: CGFloat
    private let initialOffset: CGFloat
    private var didInitialize = false

    init(topInset: CGFloat, minInset: CGFloat, initialOffset: CGFloat, content: Content) {
        self.topInset = topInset
        self.minInset = minInset
        self.initialOffset = initialOffset
        self.hostingController = UIHostingController(rootView: content)
        if #available(iOS 16.0, *) {
            self.hostingController.sizingOptions = [.intrinsicContentSize]
        }
        if #available(iOS 16.4, *) {
            self.hostingController.safeAreaRegions = []
        }
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.automaticallyAdjustsScrollIndicatorInsets = false
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        // Add view directly without VC embedding so UIKit does not propagate safe area
        // insets into the SwiftUI content, which would add invisible top padding.
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.backgroundColor = .clear
        scrollView.addSubview(hostingController.view)

        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
        ])

        onScrollViewReady?(scrollView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard !didInitialize, scrollView.bounds.height > 0 else { return }
        didInitialize = true
        // UIHostingController may have computed an initial layout before UIKit
        // established the scroll view's frame; force a re-measure at the correct width.
        hostingController.view.setNeedsLayout()
        hostingController.view.layoutIfNeeded()
        scrollView.setContentOffset(CGPoint(x: 0, y: initialOffset), animated: false)
        onDidInitialize?(scrollView)
    }

    // MARK: - UIScrollViewDelegate

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard didInitialize else { return }
        let isUserInitiated = scrollView.isDragging || scrollView.isDecelerating
        onOffsetChange?(scrollView.contentOffset.y, isUserInitiated)
        let maxY = max(0, scrollView.contentSize.height - scrollView.bounds.height)
        if scrollView.contentOffset.y >= maxY {
            onReachBottom?()
        }

        let refreshPull = min(1, max(0, -(scrollView.contentOffset.y + topInset) / 60))
        let loadMorePull = min(1, max(0, (scrollView.contentOffset.y - maxY) / 60))
        onDragProgress?(refreshPull, loadMorePull)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        onWillEndDragging?(velocity.y)

        if onPullToRefresh != nil, scrollView.contentOffset.y < -(topInset + 60) {
            scrollView.contentInset.top = topInset + 32
            targetContentOffset.pointee = CGPoint(x: 0, y: -(topInset + 32))
        }

        if onPullToLoadMore != nil {
            let maxY = max(0, scrollView.contentSize.height - scrollView.bounds.height)
            if scrollView.contentOffset.y > maxY + 60 {
                scrollView.contentInset.bottom = 60
                targetContentOffset.pointee = CGPoint(x: 0, y: maxY + 60)
            }
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y < -(topInset + 60) {
            onPullToRefresh?()
        }
        let maxY = scrollView.contentSize.height - scrollView.bounds.height
        if scrollView.contentOffset.y > maxY + 60 {
            onPullToLoadMore?()
        }
        onEndDragging?()
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        onEndDragging?()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        onEndDecelerating?()
    }
}
