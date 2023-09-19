//
//  MediaResponseModel.swift
//  Media Finder
//
//  Created by Nafea Elkassas on 10/07/2023.
//

import Foundation
struct mediaResponse: Codable {
    let resultCount: Int?
    let results: [mediaData]?
}
