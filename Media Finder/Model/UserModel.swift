//
//  UserModel.swift
//  Media Finder
//
//  Created by Nafea Elkassas on 05/05/2023.
//

import UIKit

enum Gender: String, Codable  {
    case male = "Male"
    case female = "Female"
}

struct User: Codable {
    let email: String
    let name: String
    let password: String
    let address: String
    let gender: Gender
    let phone: String
    let image: codableImage
}

struct codableImage: Codable {

    let imageData: Data?
    // Gets the image from its data (Decode)
    func getImage() -> UIImage? {
        guard let imageData = self.imageData else { return nil }
        return UIImage(data: imageData)
    }

    init(withIimage image: UIImage) {
        // Converts image into data (Encode)
        self.imageData = image.jpegData(compressionQuality: 1.0)
    }
}



