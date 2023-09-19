//
//  File.swift
//  Media Finder
//
//  Created by Nafea Elkassas on 20/05/2023.
//

import Foundation
class UserDefaultsManager{
    // singleton
    static let shared = UserDefaultsManager()
    
    private let def = UserDefaults.standard
    
    //  Functions
     func convertUserToData(user:User) {
        let encoder = JSONEncoder()
        if let encodedUser = try? encoder.encode(user) {
            def.setValue(encodedUser, forKey: UserDefaultKeys.user)
        }
    }
    
     func convertDataToUser() -> User? {
        if let userData = UserDefaults.standard.object(forKey: UserDefaultKeys.user) as? Data {
            let decoder = JSONDecoder()
            if let decodedData = try? decoder.decode(User.self, from: userData){
                return decodedData
            }
        }
        return nil 
    }
}
