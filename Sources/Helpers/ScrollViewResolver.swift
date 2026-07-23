//
//  ScrollViewResolver.swift
//  ScalingHeaderScrollView
//
//  Created by Alisa Mylnikova on 13.07.2026.
//

import SwiftUI

struct ScrollViewResolver: UIViewRepresentable {
    var onResolve: (UIScrollView) -> Void

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = .clear
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            if let scrollView = uiView.enclosingScrollView() {
                onResolve(scrollView)
            }
        }
    }
}

extension UIView {
    func enclosingScrollView() -> UIScrollView? {
        var ancestor = superview
        while let current = ancestor {
            if let scroll = current as? UIScrollView {
                return scroll
            }
            ancestor = current.superview
        }
        // Fallback for .background placement where the resolver is a sibling of the scroll view
        return superview?.subviews.compactMap { $0 as? UIScrollView }.first
    }
}
