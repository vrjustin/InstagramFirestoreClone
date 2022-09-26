//
//  RegistrationController.swift
//  InstagramFirestoreClone
//
//  Created by Justin Maronde on 9/25/22.
//

import Foundation
import UIKit

class RegistrationController: UIViewController {
    
    // MARK: - Properties
    
    private var vm = RegistrationViewModel()
    private var profileImage: UIImage?
    
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(imageLiteralResourceName: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(photoButtonAction), for: .touchUpInside)
        return button
    }()
    
    private let emailTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Email")
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    private let passwordTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let fullNameTextField = CustomTextField(placeholder: "Full Name")
    private let userNameTextField = CustomTextField(placeholder: "Username")

    private let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        button.layer.cornerRadius = 5
        button.isEnabled = false
        button.setHeight(50)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        return button
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Already have an account?", secondPart: "Sign Up")
        button.addTarget(self, action: #selector(alreadyHaveAccountAction), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObservers()
    }
    
    // MARK: - Actions
    
    @objc func handleSignup() {
        print("handle signup called")
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullNameTextField.text else { return }
        guard let username = userNameTextField.text else { return }
        guard let profileImage = self.profileImage else { return }
        let credentials = AuthCredentials(email: email, password: password,
                                          fullname: fullname, username: username,
                                          profileImage: profileImage)
        
        AuthService.registerUser(withCredential: credentials)
    }
    
    @objc func photoButtonAction() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true)
    }
    
    @objc func alreadyHaveAccountAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        
        if sender == emailTextField {
            vm.email = sender.text
        } else if sender == passwordTextField {
            vm.password = sender.text
        } else if sender == fullNameTextField {
            vm.fullname = sender.text
        } else {
            vm.username = sender.text
        }
        updateForm()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        configureGradientLayer()
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view)
        plusPhotoButton.setDimensions(height: 140, width: 140)
        plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, fullNameTextField, userNameTextField, signupButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor,
                     right: view.rightAnchor, paddingTop: 32,
                     paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.centerX(inView: view)
        alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        userNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
}

extension RegistrationController: FormViewModel {
    func updateForm() {
        signupButton.backgroundColor = vm.buttonBackgroundColor
        signupButton.setTitleColor(vm.buttonTextColor, for: .normal)
        signupButton.isEnabled = vm.formIsValid
    }
}

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 2
        plusPhotoButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        profileImage = selectedImage
        
        self.dismiss(animated: true)
    }
}
