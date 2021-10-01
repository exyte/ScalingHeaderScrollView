//
//  GeometryGetter.swift
//  ScalingHeaderView
//
//  Created by Daniil Manin on 28.09.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import SwiftUI

struct GeometryGetter: View {
    @Binding var rect: CGRect
    
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(key: RectanglePreferenceKey.self, value: geometry.frame(in: .global))
        }
        .onPreferenceChange(RectanglePreferenceKey.self) { value in
            DispatchQueue.main.async {
                rect = value
            }
        }
    }
}
