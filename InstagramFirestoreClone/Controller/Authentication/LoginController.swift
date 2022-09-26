//
//  LoginController.swift
//  InstagramFirestoreClone
//
//  Created by Justin Maronde on 9/25/22.
//

import Foundation
import UIKit

class LoginController: UIViewController {
    
    // MARK: - Properties
    
    private var vm = LoginViewModel()
    
    private let iconImage: UIImageView = {
        let iv = UIImageView(image: UIImage(imageLiteralResourceName: "Instagram_logo_white"))
        iv.contentMode = .scaleAspectFill
        return iv
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
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemPurple.withAlphaComponent(0.5)
        button.layer.cornerRadius = 5
        button.isEnabled = false
        button.setHeight(50)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleLoginButtonAction), for: .touchUpInside)
        return button
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Forgot your password?", secondPart: "Get help signing in.")
        return button
    }()
    
    private let noAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Don't have an account?", secondPart: "Sign Up")
        button.addTarget(self, action: #selector(noAccountAction), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObservers()
    }
    
    // MARK: - Actions
    
    @objc func handleLoginButtonAction() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        AuthService.loginUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Error logging in user: error is: \(error.localizedDescription)")
                return
            }
            self.dismiss(animated: true)
        }
    }
    
    @objc func noAccountAction() {
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            vm.email = sender.text
        } else {
            vm.password = sender.text
        }
        updateForm()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        configureGradientLayer()
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 80, width: 120)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton, forgotPasswordButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor,
                     right: view.rightAnchor, paddingTop: 32,
                     paddingLeft: 32, paddingRight: 32)
        
        
        view.addSubview(noAccountButton)
        noAccountButton.centerX(inView: view)
        noAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
}

extension LoginController: FormViewModel {
    func updateForm() {
        loginButton.backgroundColor = vm.buttonBackgroundColor
        loginButton.setTitleColor(vm.buttonTextColor, for: .normal)
        loginButton.isEnabled = vm.formIsValid
    }
}
