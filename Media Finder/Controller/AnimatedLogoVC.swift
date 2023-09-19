//
//  ViewController.swift
//  Media Finder
//
//  Created by Nafea Elkassas on 13/07/2023.
//

import UIKit

class AnimatedLogoVC: UIViewController {
    //MARK: - Properties
    private let imageview : UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        imageView.image = UIImage(named: "logo")
        
        return imageView
    }()
    
    //MARK: - Outlets
    @IBOutlet weak var logoImageView: UIImageView!
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageview)
        logoImageView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animate()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageview.center = view.center
    }
    
    //MARK: - Private functions
    func animate(){
        logoImageView.removeFromSuperview()
        UIView.animate(withDuration: 1.0, animations:  {
            let size = self.view.frame.size.width * 3
            let diffx = size - self.view.frame.width
            let diffy = self.view.frame.size.height - size
            self.imageview.frame = CGRect(x: -(diffx/2), y: diffy/2, width: size, height: size)
        }, completion: { _ in
            UIView.animate(withDuration: 1.5, animations: {
                self.imageview.alpha = 0
            }, completion: { _ in
                self.dealWithRoot()
            })
        })
    }
    
    //MARK: - Private Functions
    private func goToMediaVC(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: Storyboards.mainStoryboard, bundle: nil)
        let mediaVC: MediaVC = mainStoryboard.instantiateViewController(withIdentifier: Views.mediaVC) as! MediaVC
        self.navigationController?.pushViewController(mediaVC, animated: true)
    }
    
    
    private func goToSignInVC(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: Storyboards.mainStoryboard, bundle: nil)
        let signInVC: SignInVC = mainStoryboard.instantiateViewController(withIdentifier: Views.signInVC) as! SignInVC
        self.navigationController?.pushViewController(signInVC, animated: true)
    }
    private func goToSignUp(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: Storyboards.mainStoryboard, bundle: nil)
        let signUpVC: SignUpVC = mainStoryboard.instantiateViewController(withIdentifier: Views.signUpVC) as! SignUpVC
        self.navigationController?.pushViewController(signUpVC, animated: true)
        
    }
    
    
    private func dealWithRoot() {
        if let userLoggedIn = UserDefaults.standard.object(forKey: UserDefaultKeys.isUserLoggedIn) as? Bool {
            if userLoggedIn {
                goToMediaVC()
            } else {
                goToSignUp()
            }
        } else {
            goToSignUp()
        }
    }

}
