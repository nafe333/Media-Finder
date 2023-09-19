//
//  SignInVC.swift
//  Media Finder
//
//  Created by Nafea Elkassas on 19/04/2023.
//

import UIKit
import Lottie

class SignInVC: UIViewController {
    //MARK: - Properties
    let manager = sqlLiteManager.shared
    var animationView = LottieAnimationView()
    
    //MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var lottieAnimationView: LottieAnimationView!
    
       //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        setUpAnimation()
        
    }
    
    //MARK: - Actions
    @IBAction func signInBtn(_ sender: UIButton) {
        if isDataEntered(){
            if checkData(){
                saveEmailToUserDefaults(email: emailTextField.text!)
                goToMediaVC()
            }
        }
    }
}

extension SignInVC {
    
    //MARK: - Private functions
    private func setUpAnimation() {
        lottieAnimationView.backgroundColor = UIColor.clear
        animationView = .init(name: "signInAnimation")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.0
        animationView.play()
        lottieAnimationView.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                animationView.topAnchor.constraint(equalTo: lottieAnimationView.topAnchor),
                animationView.leadingAnchor.constraint(equalTo: lottieAnimationView.leadingAnchor),
                animationView.trailingAnchor.constraint(equalTo: lottieAnimationView.trailingAnchor),
                animationView.bottomAnchor.constraint(equalTo: lottieAnimationView.bottomAnchor)
            ])
    }

    
    private func goToMediaVC(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: Storyboards.mainStoryboard, bundle: nil)
        let mediaVC: MediaVC = mainStoryboard.instantiateViewController(withIdentifier: Views.mediaVC) as! MediaVC
        self.navigationController?.pushViewController(mediaVC, animated: true)
    }
    
    private func isDataEntered()->Bool{
        
        guard emailTextField.text != "" else{
            showAlert(message: "Please Enter A valid Email")
            return false
        }
        guard passwordTextField.text != "" else{
            showAlert(message: "Please Enter A valid Password")
            return false
        }
        return true
    }
    
    private func checkData() -> Bool {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let sqlLiteManager = sqlLiteManager.shared
        
        do {
            // Retrieve the user data from the database
            let users = try sqlLiteManager.database.prepare(sqlLiteManager.tableUser)
            for user in users {
                let userData = user[sqlLiteManager.userData]
                let retrievedUser = try JSONDecoder().decode(User.self, from: userData)
                if email == retrievedUser.email && password == retrievedUser.password {
                    // Save the email address to UserDefaults
                    saveEmailToUserDefaults(email: email)
                    return true
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return false
    }
    
    // Now we want to save the right email in user defaults to retrieve its data later...
    func saveEmailToUserDefaults(email: String) {
        let defaults = UserDefaults.standard
        defaults.set(email, forKey: UserDefaultKeys.userEmail)
    }
    
}
