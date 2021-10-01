//
//  ViewFrame.swift
//  ScalingHeaderView
//
//  Created by Daniil Manin on 28.09.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import SwiftUI

class ViewFrame: ObservableObject {
    var startingRect: CGRect?
    
    @Published var frame: CGRect {
        willSet {
            if newValue.minY == 0 && newValue != startingRect {
                startingRect = newValue
            }
        }
    }
    
    init() {
        self.frame = .zero
    }
}
