//
//  AlamofireManager.swift
//  Media Finder
//
//  Created by Nafea Elkassas on 11/06/2023.
//

import Foundation
import Alamofire

class APIManager {
    //MARK: - Singleton
    static let shared = APIManager()
    
    
    func getMediaData(baseURL: String, completion: @escaping (_ error: Error?, _ mediaArr: [mediaData]?) -> Void) {
        AF.request(baseURL,method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: nil).response { response in
            print(response)
            guard  response.error == nil else{
                completion(response.error, nil)
                return
            }
            guard let data = response.data else {
                print("Couldn't get data from the API !!!")
                return
            }
            do {
                let decoder = JSONDecoder()
                let mediaRes = try decoder.decode(mediaResponse.self, from: data)
                let mediaArr = mediaRes.results
                completion(nil,mediaArr)
                
            } catch {
                print(error)
            }
        }
    }
}


