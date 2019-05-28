//
//  Validation.swift
//  TextFieldComponent
//
//  Created by hesham ghalaab on 5/25/19.
//  Copyright © 2019 hesham ghalaab. All rights reserved.
//

import Foundation

enum FieldType{
    case email
    case password
    case confirmPassword(password: String?)
    case other
}

struct ValidationResponse {
    let warning: Warning?
    let isValidate: Bool
}

enum Warning: String{
    case isReuired = "Field is required"
    case enterValidEmail = "Enter a valid email"
    case passwordMustBeMoreThanEightCharacters =  "Password must be more than 8 characters"
    case passwordsAreNotMatched = "Passwords are not matched"
}

class Validation{
    
    func validate(withValidationType type: FieldType, value: String?) -> ValidationResponse{
        switch type {
        case .email:
            return isEmailValidate(withValue: value)
        case .password:
            return isPasswordValidate(withValue: value)
        case .confirmPassword(let confirmPassword):
            return isConfirmPasswordValidate(withConfirmPassword: confirmPassword, andPassword: value)
        case .other:
            guard let value = value, !value.isEmpty else {
                return ValidationResponse(warning: .isReuired, isValidate: false)
            }
            return ValidationResponse(warning: nil, isValidate: true)
        }
    }
    
    private func isEmailValidate(withValue value: String?) -> ValidationResponse{
        guard let value = value, !value.isEmpty else {
            return ValidationResponse(warning: .isReuired, isValidate: false)
        }
        
        guard checkEmailConfirmation(emailAddress: value) else{
            return ValidationResponse(warning: .enterValidEmail, isValidate: false)
        }
        
        return ValidationResponse(warning: nil, isValidate: true)
    }
    
    private func checkEmailConfirmation(emailAddress: String) -> Bool{
        let REGEX: String
        REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let emailIsGood = NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: emailAddress)
        return emailIsGood
    }
    
    private func isPasswordValidate(withValue value: String?) -> ValidationResponse{
        guard let value = value, !value.isEmpty else {
            return ValidationResponse(warning: .isReuired, isValidate: false)
        }
        
        guard checkPasswordConfirmation(password: value) else{
            return ValidationResponse(warning: .passwordMustBeMoreThanEightCharacters, isValidate: false)
        }
        
        return ValidationResponse(warning: nil, isValidate: true)
    }
    
    private func checkPasswordConfirmation(password: String) -> Bool{
        let REGEX: String
        REGEX = "^.{8,32}$"
        let passwordIsGood = NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: password)
        return passwordIsGood
    }
    
    private func isConfirmPasswordValidate(withConfirmPassword confirmPassword: String?, andPassword password: String?) -> ValidationResponse{
        guard let confirmPassword = confirmPassword, !confirmPassword.isEmpty ,
              let password = password, !password.isEmpty else {
            return ValidationResponse(warning: .isReuired, isValidate: false)
        }
        
        guard password == confirmPassword else{
            return ValidationResponse(warning: .passwordsAreNotMatched, isValidate: false)
        }
        
        return ValidationResponse(warning: nil, isValidate: true)
    }
}





