//
//  ColorScalingHeader.swift
//  Example
//
//  Created by Daniil Manin on 28.09.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import SwiftUI
import ScalingHeaderView
import Introspect

struct ColorScalingHeader: View {
    
    @State private var selectedColor: Color = .green
    
    var body: some View {
        ScalingHeaderScrollView { _ in
            selectedColor
        } content: {
            AutosizingList {
                scrollContent
            }.introspectScrollView { scrollView in
                scrollView.isScrollEnabled = false
            }
        }
        .height(min: 90)
    }
    
    // MARK: - Private
    
    private var scrollContent: some View {
        LazyVStack {
            ForEach((0...colorSet.count - 1), id: \.self) { index in
                colorRow(index: index)
            }
            .background(
                Color.gray
                    .opacity(0.15)
                    .clipShape(RoundedRectangle(cornerRadius: 8.0))
            )
        }
    }
    
    private func colorRow(index: Int) -> some View {
        HStack {
            Text(colorSet[index].name)
            Spacer()
            colorSet[index]
                .clipShape(Circle())
                .frame(width: 30.0, height: 30.0)
        }
        .padding()
        .contentShape(Rectangle())
        .onTapGesture {
            selectedColor = colorSet[index]
        }
    }
}


let colorSet: [Color] = [.red, .blue, .green, .black, .pink, .purple, .yellow,
                            .red, .blue, .green, .black, .pink, .purple, .yellow]

extension Color {
    var name: String {
        UIColor(self).accessibilityName
    }
}
