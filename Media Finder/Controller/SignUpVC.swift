//
//  ViewController.swift
//  Media Finder
//
//  Created by Nafea Elkassas on 19/04/2023.
//

import SDWebImage
class SignUpVC: UIViewController {
    
    //MARK: - Properties
    private var gender: Gender = .female // default value
    private var imagePicker = UIImagePickerController()
    private var isImagePicked: Bool = false
    var navigationBar : UINavigationBar!
    
    //MARK: - Outlets
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var signUpButton: UIButton!
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.clipsToBounds = true
        signUpButton.layer.cornerRadius = 10
        imagePicker.delegate = self
        setUpNavigatioBar()
    }
    
    
    
    
    //MARK: - Actions
    @IBAction func maleFemaleSwitch(_ sender: UISwitch) {
        if sender.isOn {
            gender = .female
        } else {
            gender = .male
        }
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        if isDataEntered(){
            if isDataValid(){
                // new
                sqlLiteManager.shared.createTable()
                handleSignIn()
            }
        }
        else {
            print("Invalid Sign Up Information")
        }
    }
    
    @IBAction func goToMapBtnPressed(_ sender: UIButton) {
        goToMapVC()
    }
    
    @IBAction func goToImagePicketBtmTapped(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true)
        isImagePicked = true
    }
}

//MARK: - Private Functions
extension SignUpVC {
    
    private func setUpNavigatioBar(){
        self.navigationBar = UINavigationBar()
        self.view.addSubview(self.navigationBar)
        self.navigationItem.title = "Sign Up Page"
        navigationItem.hidesBackButton = true
    }
    private func handleSignIn(){
        do {
            let user = User(email: emailTextField.text ?? "",
                            name: fullNameTextField.text ?? "",
                            password: passwordTextField.text ?? "",
                            address: addressTextField.text ?? "",
                            gender: gender,
                            phone: phoneTextField.text ?? "",
                            image: codableImage(withIimage: userImageView.image!))
            
            let userData = try JSONEncoder().encode(user)
            sqlLiteManager.shared.insertUser(user: user, userData: userData)
        } catch {
            print("Error encoding user data: \(error.localizedDescription)")
        }
        goToSignIn()
    }
    
    //MARK: - Navigation Functions
    private func goToSignIn(){
        let mainStroyboard: UIStoryboard = UIStoryboard(name: Storyboards.mainStoryboard, bundle: nil)
        let signInVC: SignInVC = mainStroyboard.instantiateViewController(withIdentifier: Views.signInVC) as! SignInVC
        self.navigationController?.pushViewController(signInVC, animated: true)
    }
    
    private func goToMapVC(){
        let mainStroyboard: UIStoryboard = UIStoryboard(name: Storyboards.mainStoryboard, bundle: nil)
        let mapVC: MapVC = mainStroyboard.instantiateViewController(withIdentifier: Views.mapVC) as! MapVC
        mapVC.delegate = self
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    
    //MARK: - Validating Functions
    
    private func isDataEntered() -> Bool{
        guard isImagePicked != false else {
            showAlert(message: "Please Choose a Profile Photo")
            return false
        }
        guard fullNameTextField.text != "" else{
            showAlert(message: "Please Enter A valid Name")
            return false
        }
        guard emailTextField.text != "" else{
            showAlert(message: "Please Enter A valid Email")
            return false
        }
        guard passwordTextField.text != "" else{
            showAlert(message: "Please Enter A valid Password")
            return false
        }
        guard phoneTextField.text != "" else{
            showAlert(message: "Please Enter A valid Phone")
            return false
        }
        guard addressTextField.text != "" else{
            showAlert(message: "Please Enter A valid Address")
            return false
        }
        return true
    }
    
    private func isDataValid() -> Bool{
        guard Validator.shared().isValidEmail(email: emailTextField.text!) else {
            showAlert(message: "Please enter valid email")
            return false
        }
        guard Validator.shared().isValidPassword(password: passwordTextField.text!) else {
            showAlert(message: "Please enter valid password")
            return false
        }
        guard Validator.shared().isValidPhone(phone: phoneTextField.text!)  else {
            showAlert(message: "Please enter valid phone number")
            return false
        }
        return true
    }
    
    
}
//3
extension SignUpVC: sendLocationDelegate{
    func sendLocationAddress(address: String) {
        addressTextField.text = address
    }
}

//MARK: -  Image Picker functions
extension SignUpVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            isImagePicked = true
            userImageView.image = pickedImage
        }
        dismiss(animated: true)
    }
}



