//
//  GeometryGetter.swift
//  ScalingHeaderScrollView
//
//  Created by Daniil Manin on 28.09.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import SwiftUI

@MainActor
final class ViewFrame: ObservableObject {

    var startingRect: CGRect?

    @Published var frame: CGRect {
        willSet {
            if newValue.minY == 0 && newValue != startingRect {
                self.startingRect = newValue
            }
        }
    }

    init() {
        self.frame = .zero
    }
}

extension View {
    func frameGetter(_ frame: Binding<CGRect>) -> some View {
        modifier(FrameGetter(frame: frame))
    }
}

struct FrameRectPreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {}
}

struct FrameGetter: ViewModifier {

    @Binding var frame: CGRect

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    EmptyView()
                        .preference(key: FrameRectPreferenceKey.self, value: proxy.frame(in: .global))
                }
            )
            .onPreferenceChange(FrameRectPreferenceKey.self) { rect in
                if rect.integral != self.frame.integral {
                    self.frame = rect
                }
            }
    }
}
