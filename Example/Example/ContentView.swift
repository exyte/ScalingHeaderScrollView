//
//  ContentView.swift
//  Example
//
//  Created by Alisa Mylnikova on 16/09/2021.
//  Copyright © 2019 Exyte. All rights reserved.
//

import SwiftUI
import ScalingHeaderView

struct ContentView: View {
    @Environment(\.presentationMode) var presentationMode

    var backButton: some View {
        Button(action: {self.presentationMode.wrappedValue.dismiss() }) {
            Image(systemName: "arrow.backward")
                .frame(width: 40, height: 40)
        }
    }
    
    init() {
        UINavigationBar.appearance().barTintColor = .clear
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 32.0) {
                Spacer()
                
                NavigationLink(destination: SimpleScalingHeader()) {
                    Text("Simple Scaling Header")
                }
                
                NavigationLink(destination: MapScalingHeader()) {
                    Text("Map Scaling Header")
                }
                
                NavigationLink(destination: ColorScalingHeader()) {
                    Text("Color Scaling Header")
                }
                
                NavigationLink(destination: RequestScalingHeader()) {
                    Text("Request Scaling Header")
                }
                
                NavigationLink(destination: TabScalingHeader()) {
                    Text("Tab Scaling Header")
                }

                NavigationLink( destination: ProfileScreen()) {
                        Text("Profile Screen")
                }
                
                Spacer()
            }
            .offset(y: -50)
        }
    }
}
