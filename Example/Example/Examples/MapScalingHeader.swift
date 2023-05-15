//
//  MapScalingHeader.swift
//  Example
//
//  Created by Daniil Manin on 28.09.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import SwiftUI
import ScalingHeaderScrollView
import MapKit

struct MapScalingHeader: View {

    @Environment(\.presentationMode) var presentationMode
    
    @State private var isLoading: Bool = false
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
        span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            ScalingHeaderScrollView {
                Map(coordinateRegion: $region)
            } content: {
                Text(defaultDescription)
                    .padding()
            }
            .height(min: 150.0, max: UIScreen.main.bounds.height - 150)
            .headerSnappingPositions(snapPositions: [0, 0.5, 1])
            .initialSnapPosition(initialSnapPosition: 0.5)
            .pullToRefresh(isLoading: $isLoading) {
                updateRegion()
                isLoading = false
            }
            .ignoresSafeArea()

            Button("", action: { self.presentationMode.wrappedValue.dismiss() })
                .buttonStyle(CircleButtonStyle(imageName: "arrow.backward"))
                .padding(.leading, 16)
        }
    }
    
    // MARK: - Private
    
    private func updateRegion() {
        DispatchQueue.main.async {
            region.center = CLLocationCoordinate2D(
                latitude: Double.random(in: -90...90),
                longitude: Double.random(in: -180...180)
            )
            isLoading = false
        }
    }
}
