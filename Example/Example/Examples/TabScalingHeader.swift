//
//  TabScalingHeader.swift
//  Example
//
//  Created by Daniil Manin on 30.09.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import SwiftUI
import ScalingHeaderView

struct TabScalingHeader: View {
    
    enum Screen {
        case first, second, third
    }
    
    @State private var selectedScreen: Screen = .first
    @State private var scrollToTop: Bool = false
    
    var body: some View {
        ScalingHeaderScrollView { _ in
            VStack(alignment: .center, spacing: 0) {
                Image("image_1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
                tabBar
            }
            .frame(width: UIScreen.main.bounds.width)
        } content: {
            content
        }
        .allowHeaderScale(false)
        .allowsHeaderCollapse(false)
        .scrollToTop(immediately: $scrollToTop)
    }
    
    // MARK: - Private
    
    private var tabBar: some View {
        ZStack {
            Color.white
            Color.gray.opacity(0.15)
            HStack {
                Spacer()
                Text("One")
                    .onTapGesture {
                        selectedScreen = .first
                        scrollToTop = true
                    }
                Spacer()
                Text("Two")
                    .onTapGesture {
                        selectedScreen = .second
                        scrollToTop = true
                    }
                Spacer()
                Text("Three")
                    .onTapGesture {
                        selectedScreen = .third
                        scrollToTop = true
                    }
                Spacer()
            }
        }
        .frame(height: 50.0)
    }
    
    private var content: some View {
        ZStack {
            switch selectedScreen {
            case .first:
                Text("1\n\n" + defaultDescription)
                    .padding()
            case .second:
                Text("2\n\n" + defaultDescription)
                    .padding()
            case .third:
                Text("3\n\n" + defaultDescription)
                    .padding()
            }
        }
    }
}
