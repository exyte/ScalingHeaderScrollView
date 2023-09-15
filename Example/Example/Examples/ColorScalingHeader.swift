//
//  ColorScalingHeader.swift
//  Example
//
//  Created by Daniil Manin on 28.09.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import SwiftUI
import ScalingHeaderScrollView
import SwiftUIIntrospect

struct ColorScalingHeader: View {

    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedColor: Color = .green

    var body: some View {
        ZStack(alignment: .topLeading) {
            ScalingHeaderScrollView {
                selectedColor
            } content: {
                scrollContent
                    .padding()
            }
            .height(min: 110)
            .ignoresSafeArea()
            
            Button("", action: { self.presentationMode.wrappedValue.dismiss() })
                .buttonStyle(CircleButtonStyle(imageName: "arrow.backward"))
                .padding(.leading, 16)
        }
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
