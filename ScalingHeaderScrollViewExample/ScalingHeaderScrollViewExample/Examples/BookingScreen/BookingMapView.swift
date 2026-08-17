//
//  BookingMapView.swift
//  ScalingHeaderScrollViewExample
//
//  Created by Alisa Mylnikova on 14.08.2026.
//

import SwiftUI
import UIKit
import MapKit

struct BookingMapView: UIViewControllerRepresentable {

    @ObservedObject var viewModel: BookingScreenViewModel

    private let mapHeight: CGFloat = 350

    func makeUIViewController(context: Context) -> BookingMapViewController {
        BookingMapViewController(viewModel: viewModel, mapHeight: mapHeight)
    }

    func updateUIViewController(_ vc: BookingMapViewController, context: Context) {
        vc.updateContent(viewModel: viewModel)
    }
}

class BookingMapViewController: UIViewController {

    private let mapHeight: CGFloat
    private var viewModel: BookingScreenViewModel
    private var hostingController: UIHostingController<BookingMapContent>?

    init(viewModel: BookingScreenViewModel, mapHeight: CGFloat) {
        self.viewModel = viewModel
        self.mapHeight = mapHeight
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true

        let content = UIHostingController(rootView: BookingMapContent(viewModel: viewModel, height: mapHeight))
        addChild(content)
        content.view.backgroundColor = .clear
        content.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(content.view)

        NSLayoutConstraint.activate([
            content.view.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            content.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            content.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            content.view.heightAnchor.constraint(equalToConstant: mapHeight)
        ])

        content.didMove(toParent: self)
        hostingController = content
    }

    func updateContent(viewModel: BookingScreenViewModel) {
        hostingController?.rootView = BookingMapContent(viewModel: viewModel, height: mapHeight)
    }
}

private struct BookingMapContent: View {

    @ObservedObject var viewModel: BookingScreenViewModel
    var height: CGFloat

    var body: some View {
        Map(initialPosition: .region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 35.01266423456241, longitude: 34.057450219436646),
                latitudinalMeters: 400,
                longitudinalMeters: 400
            )
        ), interactionModes: []) {
            ForEach(viewModel.hotels) { place in
                Annotation(place.id.uuidString, coordinate: place.coordinate) {
                    mapMarker(isSelected: place == viewModel.currentHotel, price: place.price)
                        .offset(y: -15)
                        .onTapGesture {
                            viewModel.select(hotel: place)
                        }
                }
            }
        }
        .frame(height: height)
    }

    private func mapMarker(isSelected: Bool = false, price: Int) -> some View {
        Text("$ \(price)")
            .padding(.horizontal, 12)
            .padding(.vertical, 5)
            .fontBold(color: isSelected ? .white : .black, size: 14)
            .background(
                ZStack {
                    Triangle()
                        .fill(isSelected ? Color.appBookingBlue : .white)
                        .offset(y: 16)
                        .frame(width: 12, height: 8)
                    RoundedRectangle(cornerRadius: 30)
                        .fill(isSelected ? Color.appBookingBlue : .white)
                }
            )
    }
}
