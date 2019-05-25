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
    let warning: String?
    let isValidate: Bool
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
            guard let _ = value else {
                return ValidationResponse(warning: "field is required", isValidate: false)
            }
            return ValidationResponse(warning: nil, isValidate: true)
        }
    }
    
    private func isEmailValidate(withValue value: String?) -> ValidationResponse{
        guard let value = value, !value.isEmpty else {
            return ValidationResponse(warning: "field is required", isValidate: false)
        }
        
        guard checkEmailConfirmation(emailAddress: value) else{
            return ValidationResponse(warning: "enter a valid email", isValidate: false)
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
            return ValidationResponse(warning: "field is required", isValidate: false)
        }
        
        guard checkPasswordConfirmation(password: value) else{
            return ValidationResponse(warning: "password must be more than 8 characters", isValidate: false)
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
            return ValidationResponse(warning: "field is required", isValidate: false)
        }
        
        guard password == confirmPassword else{
            return ValidationResponse(warning: "password are not matched", isValidate: false)
        }
        
        return ValidationResponse(warning: nil, isValidate: true)
    }
}





