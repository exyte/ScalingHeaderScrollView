//
//  RequestScalingHeader.swift
//  Example
//
//  Created by Daniil Manin on 29.09.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import SwiftUI
import ScalingHeaderView

struct RequestScalingHeader: View {

    @Environment(\.presentationMode) var presentationMode
    
    @State private var isLoading: Bool = false
    @State private var image: UIImage = UIImage()
    @ObservedObject private var imageLoader = ImageLoaderService()
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            ScalingHeaderView {
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.15))
                    Image(uiImage: image)
                }
            } content: {
                Text("↓ Pull to refresh ↓")
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .pullToRefresh(isLoading: $isLoading) {
                imageLoader.load()
            }
            .height(min: 90.0, max: 300.0)
            .onReceive(imageLoader.$image) { image in
                isLoading = false
                self.image = image
            }
            .onAppear {
                imageLoader.load()
            }
            .ignoresSafeArea()
            
            Button("", action: { self.presentationMode.wrappedValue.dismiss() })
                .buttonStyle(CircleButtonStyle(imageName: "arrow.backward"))
                .padding(.leading, 16)
        }
    }
}

final class ImageLoaderService: ObservableObject {
    
    @Published var image: UIImage = UIImage()
    
    func load() {
        guard let url = URL(string: "https://picsum.photos/500") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.image = UIImage(data: data) ?? UIImage()
            }
        }.resume()
    }
}
