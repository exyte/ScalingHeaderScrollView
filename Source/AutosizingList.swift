//
//  AutosizingList.swift
//  ScalingHeaderScrollView
//
//  Created by Daniil Manin on 28.09.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import SwiftUI

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
        .introspect(.list, on: .iOS(.v15), scope:.receiver) { tableView in
            tableView.backgroundColor = .clear
            tableView.isScrollEnabled = false
            tableContentHeight = tableView.contentSize.height
            observation = tableView.observe(\.contentSize) { tableView, value in
                tableContentHeight = tableView.contentSize.height
            }
        }
        .frame(height: tableContentHeight)
    }
}
