//
//  RequestScalingHeader.swift
//  Example
//
//  Created by Daniil Manin on 29.09.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import SwiftUI
import ScalingHeaderScrollView

struct RequestScalingHeader: View {

    @Environment(\.presentationMode) var presentationMode

    @State private var isActive: Bool = true

    private let colorSet: [Color] = [.red, .blue, .green, .black, .pink, .purple, .yellow]
    @State private var displayedColors: [Color] = []

    var body: some View {
        ZStack(alignment: .topLeading) {
            ScalingHeaderScrollView {
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.15))
                    Image("background")
                        .resizable()
                }
            } content: {
                VStack(alignment: .center) {
                    InformationLabel(text: "↓ Pull to refresh ↓")
                    InformationLabel(text: "↑ Pull to load more ↑")
                    Divider()
                    Text("Squares")
                        .font(.largeTitle)
                        .padding()
                    scrollContent
                        .padding()
                }
                .padding()
            }
            .pullToRefresh(isActive: $isActive) {
                await shuffleDataSource(delay: 3)
            }
            .pullToLoadMore(contentOffset: 50) {
                try? await Task.sleep(for: .seconds(3))
                displayedColors += (0..<5).map { _ in colorSet.randomElement() ?? .red }
            }
            .height(min: 90.0, max: 250)
            .ignoresSafeArea()
            .onAppear {
                displayedColors = (0..<5).map { _ in colorSet.randomElement() ?? .red }
            }

            Button("", action: { self.presentationMode.wrappedValue.dismiss() })
                .buttonStyle(CircleButtonStyle(imageName: "arrow.backward"))
                .padding(.leading, 16)
        }
    }

    private func shuffleDataSource(delay: Double) async {
        isActive = false
        try? await Task.sleep(for: .seconds(delay))
        withAnimation(.easeIn(duration: 0.2)) {
            self.displayedColors.shuffle()
        }

        Task.detached {
            try? await Task.sleep(for: .seconds(6))
            await MainActor.run {
                isActive = true
            }
        }
    }

    // MARK: - Private
    private var scrollContent: some View {
        LazyVStack {
            ForEach(Array(zip(displayedColors.indices, displayedColors)), id: \.0) { index, color in
                Rectangle()
                    .rotation(.degrees(45), anchor: .bottomLeading)
                    .scale(sqrt(2), anchor: .bottomLeading)
                    .frame(width: 200, height: 200)
                    .background(displayedColors.reversed()[index])
                    .foregroundColor(color)
                    .clipped()
            }
        }
    }
}

// MARK: - Supported Views

struct InformationLabel: View {
    private var text: String

    init(text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .multilineTextAlignment(.center)
            .padding()
    }
}
