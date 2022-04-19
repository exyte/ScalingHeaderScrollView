//
//  ScalingHeaderScrollViewDelegate.swift
//  ScalingHeaderScrollView
//
//  Created by Daniil Manin on 28.09.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import UIKit

final class ScalingHeaderScrollViewDelegate: NSObject, ObservableObject, UIScrollViewDelegate {
    
    var didPullToRefresh: () -> Void = { }
    var didScroll: () -> Void = {}
    var didEndDragging = {}

    // MARK: - UIScrollViewDelegate

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y < -60 {
            didPullToRefresh()
        }
        didEndDragging()
    }
}
