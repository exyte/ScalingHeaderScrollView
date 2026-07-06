//
//  AutosizingList.swift
//  ScalingHeaderScrollView
//
//  Created by Daniil Manin on 28.09.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import SwiftUI
import SwiftUIIntrospect

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
        .introspect(.list, on: .iOS(.v15)) { tableView in
            introspectScrollView(tableView)
        }
        .introspect(.list, on: .iOS(.v16, .v17, .v18, .v26)) { collectionView in
            introspectScrollView(collectionView)
        }
        .frame(height: tableContentHeight)
    }

    private func introspectScrollView(_ scrollView: UIScrollView) {
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
