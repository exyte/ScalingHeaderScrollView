//
//  ProfileScreenViewModel.swift
//  Example
//
//  Created by Danil Kristalev on 01.11.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import Foundation
import Combine

class ProfileScreenViewModel: ObservableObject {
    @Published var avatarImage: String = "profileAvatar"
}
