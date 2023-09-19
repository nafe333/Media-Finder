//
//  UIViewControllerWithAlert.swift
//  Media Finder
//
//  Created by Nafea Elkassas on 22/05/2023.
//

import UIKit
extension UIViewController{
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "Sorry", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true)
    }

}
