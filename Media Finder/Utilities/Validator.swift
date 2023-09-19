//
//  Validator.swift
//  Media Finder
//
//  Created by Nafea Elkassas on 22/05/2023.
//

import Foundation

class Validator{
    //MARK: - Singleton
    private static let sharedInstance = Validator()
    
    static func shared() -> Validator{
        return Validator.sharedInstance
    }
       //MARK: - Properties
    private let format = "SELF MATCHES %@"
    
       //MARK: - Validating Functions
    func isValidEmail(email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: email)
    }
    
    func isValidPassword (password: String) -> Bool {
        let regex = "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}"
        let pred = NSPredicate( format: format, regex )
        return pred.evaluate(with: password)
    }
    
    func isValidPhone (phone: String) -> Bool {
        let regex = "^[0-9]{11}$"
        let pred = NSPredicate( format: format, regex )
        return pred.evaluate(with: phone)
    }
}
