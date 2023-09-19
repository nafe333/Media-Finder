//
//  ProfileVC.swift
//  Media Finder
//
//  Created by Nafea Elkassas on 27/04/2023.
//

import UIKit

class ProfileVC: UIViewController {
    //MARK: - Properties
    let manager = sqlLiteManager.shared
    var users = [User]()
    
    //MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!

    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
        profileImageView.layer.borderWidth = 2
            profileImageView.clipsToBounds = true
        self.navigationItem.title = "Profile Page"
        handleRetrievingData()
        
    }
    
    //MARK: - Actions
    @IBAction func logOutBTN(_ sender: UIButton) {
        let def = UserDefaults.standard
        def.set(false, forKey:  UserDefaultKeys.isUserLoggedIn)
        if let delegate = UIApplication.shared.delegate as? AppDelegate{
             delegate.goToSignInVC()
        }
    }
   //MARK: - Private Methods
   private func handleRetrievingData(){
        let defaults = UserDefaults.standard
        let userEmail = defaults.string(forKey: UserDefaultKeys.userEmail)
       let users = manager.retrieveData()
        for user in users {
            if userEmail == user.email {
                nameLabel.text = user.name
                addressLabel.text = user.address
                phoneLabel.text = user.phone
                emailLabel.text = user.email
                genderLabel.text = user.gender.rawValue
                profileImageView.image = user.image.getImage()
            }
        }
    }
}
