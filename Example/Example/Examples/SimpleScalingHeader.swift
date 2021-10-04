//
//  SimpleScalingHeader.swift
//  Example
//
//  Created by Daniil Manin on 28.09.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import SwiftUI
import ScalingHeaderView

struct SimpleScalingHeader: View {
    
    @State private var selectedImage: String = "image_1"
    @State private var isLoading: Bool = false
    
    var body: some View {
        ScalingHeaderScrollView { _ in
            Image(selectedImage)
        } content: {
            Text(defaultDescription)
                .padding()
        }
        .pullToRefresh(isLoading: $isLoading) {
            changeImage()
        }
        .allowsHeaderCollapse(false)
    }
    
    // MARK: - Private
    
    private func changeImage() {
        selectedImage = selectedImage == "image_1" ? "image_2" : "image_1"
        isLoading = false
    }
}
