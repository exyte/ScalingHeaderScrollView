//
//  TabScalingHeader.swift
//  Example
//
//  Created by Daniil Manin on 30.09.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import SwiftUI
import ScalingHeaderScrollView

struct TabScalingHeader: View {

    enum Tab: String, CaseIterable {
        case one, two, three
        var title: String { rawValue.capitalized }
    }

    @Environment(\.presentationMode) var presentationMode

    @State private var selectedTab: Tab = .one

    private static let tabBarHeight: CGFloat = 50
    private static let maxHeight: CGFloat = 300

    private static var safeAreaTop: CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first { $0.isKeyWindow }?.safeAreaInsets.top ?? 44
    }

    private static var minHeight: CGFloat { (tabBarHeight + safeAreaTop) * 2 }

    var body: some View {
        ZStack(alignment: .topLeading) {
            ScalingHeaderTabView(
                selection: $selectedTab,
                minHeight: Self.minHeight,
                maxHeight: Self.maxHeight
            ) { height, _ in
                VStack(spacing: 0) {
                    Image("image_1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: max(0, height - Self.tabBarHeight))
                        .clipped()

                    tabBar
                }
            } pageContent: { tab in
                pageContent(for: tab)
            }

            Button("", action: { presentationMode.wrappedValue.dismiss() })
                .buttonStyle(CircleButtonStyle(imageName: "arrow.backward"))
                .padding(.leading, 16)
                .padding(.top, Self.safeAreaTop + 8)
        }
        .ignoresSafeArea()
    }

    // MARK: - Private

    private var tabBar: some View {
        ZStack {
            Color.white
            Color.gray.opacity(0.15)
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.self) { tab in
                    Text(tab.title)
                        .fontWeight(selectedTab == tab ? .semibold : .regular)
                        .frame(maxWidth: .infinity)
                        .onTapGesture { selectedTab = tab }
                }
            }
        }
        .frame(height: Self.tabBarHeight)
    }

    private func pageContent(for tab: Tab) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(tab.rawValue.uppercased())
                .fontBold(size: 24)
                .padding(.bottom, 8)

            Text(defaultDescription)
                .fontRegular(size: 16)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
