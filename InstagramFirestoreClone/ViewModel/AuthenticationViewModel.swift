//
//  AuthenticationViewModel.swift
//  InstagramFirestoreClone
//
//  Created by Justin Maronde on 9/25/22.
//

import Foundation
import UIKit

protocol FormViewModel {
    func updateForm()
}

protocol AuthentificationViewModel {
    var formIsValid: Bool { get }
    var buttonBackgroundColor: UIColor { get }
    var buttonTextColor: UIColor { get }
}

struct LoginViewModel: AuthentificationViewModel {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? .systemBlue : .systemPurple.withAlphaComponent(0.5)
    }
    
    var buttonTextColor: UIColor {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
}

struct RegistrationViewModel: AuthentificationViewModel {
    var email: String?
    var password: String?
    var fullname: String?
    var username: String?
    var formIsValid: Bool {
        return email?.isEmpty == false &&
            password?.isEmpty == false &&
            fullname?.isEmpty == false &&
            username?.isEmpty == false
    }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? .systemBlue : .systemPurple.withAlphaComponent(0.5)
    }
    
    var buttonTextColor: UIColor {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
}
