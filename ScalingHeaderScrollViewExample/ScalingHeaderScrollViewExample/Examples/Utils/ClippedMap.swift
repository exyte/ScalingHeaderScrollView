//
//  ClippedMap.swift
//  ScalingHeaderScrollViewExample
//

import SwiftUI
import MapKit

// MKMapView doesn't respect SwiftUI clipping for hit testing — its gesture recognizers
// fire across the full UIKit frame regardless of what SwiftUI clips visually.
// The container's UIKit bounds always match the currently visible header height (SwiftUI
// sizes it to currentHeaderHeight), so the default bounds.contains hitTest is accurate.
// MKMapView is pinned top+sides with a fixed maxHeight so the map content stays stable
// while the clip window shrinks/grows during scroll.
class ClippedMapContainerView: UIView {}

struct ClippedMap: UIViewRepresentable {

    @Binding var region: MKCoordinateRegion
    var maxHeight: CGFloat

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> ClippedMapContainerView {
        let container = ClippedMapContainerView()
        container.clipsToBounds = true

        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = context.coordinator
        container.addSubview(mapView)

        NSLayoutConstraint.activate([
            mapView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            mapView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            mapView.heightAnchor.constraint(equalToConstant: maxHeight)
        ])

        context.coordinator.mapView = mapView
        mapView.setRegion(region, animated: false)
        return container
    }

    func updateUIView(_ uiView: ClippedMapContainerView, context: Context) {
        guard let mapView = context.coordinator.mapView else { return }

        let current = mapView.region.center
        let sameCenter = abs(current.latitude - region.center.latitude) < 0.00001 &&
                         abs(current.longitude - region.center.longitude) < 0.00001
        if !sameCenter {
            mapView.setRegion(region, animated: true)
        }
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: ClippedMap
        weak var mapView: MKMapView?

        init(_ parent: ClippedMap) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            let newRegion = mapView.region
            DispatchQueue.main.async {
                self.parent.region = newRegion
            }
        }
    }
}
