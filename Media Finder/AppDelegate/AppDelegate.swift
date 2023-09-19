//
//  AppDelegate.swift
//  Media Finder
//
//  Created by Nafea Elkassas on 19/04/2023.
//

import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
       //MARK: - Properties
    var window: UIWindow?
    private let mainStoryboard: UIStoryboard = UIStoryboard(name: Storyboards.mainStoryboard, bundle: nil)


   //MARK: - Delegate functions
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        handleRoot()
        sqlLiteManager.shared.setConnection()
        UINavigationBar.appearance().barTintColor = UIColor(red: 146/255, green: 192/255, blue: 217/255, alpha: 1.0)

        return true
    }
}

extension AppDelegate {
    
       //MARK: - Functions
    private func handleRoot(){
        let logoAnimationVC = mainStoryboard.instantiateViewController(withIdentifier: Views.animatedLogoVC) as! AnimatedLogoVC
        let navigationController = UINavigationController(rootViewController: logoAnimationVC)
        window?.rootViewController = navigationController
    }
    


    public func goToSignInVC(){
        let rootVC = mainStoryboard.instantiateViewController(withIdentifier: Views.signInVC) as! SignInVC
        let navigationController = UINavigationController(rootViewController: rootVC)
        window?.rootViewController = navigationController
    }
}

