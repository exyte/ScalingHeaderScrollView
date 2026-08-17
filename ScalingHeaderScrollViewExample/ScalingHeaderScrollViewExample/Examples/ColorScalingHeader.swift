//
//  ColorScalingHeader.swift
//  Example
//
//  Created by Daniil Manin on 28.09.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import SwiftUI
import ScalingHeaderScrollView

struct ColorScalingHeader: View {

    @Environment(\.presentationMode) var presentationMode

    @State private var selectedColor: Color = samplePalette[0].color

    var body: some View {
        ZStack(alignment: .topLeading) {
            ScalingHeaderScrollView(minHeight: 110) { _, _ in
                selectedColor
            } content: {
                scrollContent
                    .padding()
            }
            .ignoresSafeArea()

            Button("", action: { self.presentationMode.wrappedValue.dismiss() })
                .buttonStyle(CircleButtonStyle(imageName: "arrow.backward"))
                .padding(.leading, 16)
        }
    }

    // MARK: - Private

    private var scrollContent: some View {
        LazyVStack {
            ForEach(samplePalette.indices, id: \.self) { index in
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
            Text(samplePalette[index].name)
            Spacer()
            samplePalette[index].color
                .clipShape(Circle())
                .frame(width: 30.0, height: 30.0)
        }
        .padding()
        .contentShape(Rectangle())
        .onTapGesture {
            selectedColor = samplePalette[index].color
        }
    }
}
