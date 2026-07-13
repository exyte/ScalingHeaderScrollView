//
//  AutosizingList.swift
//  ScalingHeaderScrollView
//
//  Created by Daniil Manin on 28.09.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import SwiftUI

@MainActor
public struct AutosizingList<Content: View>: View {

    var content: Content

    @State private var observation: NSKeyValueObservation?
    @State private var tableContentHeight: CGFloat = 0.0

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }

    public var body: some View {
        List {
            content
        }
        .background(ScrollViewResolver { configure(scrollView: $0) })
        .frame(height: tableContentHeight)
    }

    private func configure(scrollView: UIScrollView) {
        guard observation == nil else { return }
        scrollView.backgroundColor = .clear
        scrollView.isScrollEnabled = false
        tableContentHeight = scrollView.contentSize.height
        observation = scrollView.observe(\.contentSize) { scrollView, _ in
            Task { @MainActor in
                tableContentHeight = scrollView.contentSize.height
            }
        }
    }
}
