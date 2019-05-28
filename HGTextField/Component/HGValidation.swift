//
//  HGValidation.swift
//  HGTextField
//
//  Created by hesham ghalaab on 5/25/19.
//  Copyright © 2019 hesham ghalaab. All rights reserved.
//

import Foundation

enum HGFieldType{
    case email
    case password
    case confirmPassword(password: String?)
    case other
}

struct HGValidationResponse {
    let warning: HGWarning?
    let isValidate: Bool
}

enum HGWarning: String{
    case isReuired = "Field is required"
    case enterValidEmail = "Enter a valid email"
    case passwordMustBeMoreThanEightCharacters =  "Password must be more than 8 characters"
    case passwordsAreNotMatched = "Passwords are not matched"
}

class HGValidation{
    
    func validate(withValidationType type: HGFieldType, value: String?) -> HGValidationResponse{
        switch type {
        case .email:
            return isEmailValidate(withValue: value)
        case .password:
            return isPasswordValidate(withValue: value)
        case .confirmPassword(let confirmPassword):
            return isConfirmPasswordValidate(withConfirmPassword: confirmPassword, andPassword: value)
        case .other:
            guard let value = value, !value.isEmpty else {
                return HGValidationResponse(warning: .isReuired, isValidate: false)
            }
            return HGValidationResponse(warning: nil, isValidate: true)
        }
    }
    
    private func isEmailValidate(withValue value: String?) -> HGValidationResponse{
        guard let value = value, !value.isEmpty else {
            return HGValidationResponse(warning: .isReuired, isValidate: false)
        }
        
        guard checkEmailConfirmation(emailAddress: value) else{
            return HGValidationResponse(warning: .enterValidEmail, isValidate: false)
        }
        
        return HGValidationResponse(warning: nil, isValidate: true)
    }
    
    private func checkEmailConfirmation(emailAddress: String) -> Bool{
        let REGEX: String
        REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let emailIsGood = NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: emailAddress)
        return emailIsGood
    }
    
    private func isPasswordValidate(withValue value: String?) -> HGValidationResponse{
        guard let value = value, !value.isEmpty else {
            return HGValidationResponse(warning: .isReuired, isValidate: false)
        }
        
        guard checkPasswordConfirmation(password: value) else{
            return HGValidationResponse(warning: .passwordMustBeMoreThanEightCharacters, isValidate: false)
        }
        
        return HGValidationResponse(warning: nil, isValidate: true)
    }
    
    private func checkPasswordConfirmation(password: String) -> Bool{
        let REGEX: String
        REGEX = "^.{8,32}$"
        let passwordIsGood = NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: password)
        return passwordIsGood
    }
    
    private func isConfirmPasswordValidate(withConfirmPassword confirmPassword: String?, andPassword password: String?) -> HGValidationResponse{
        guard let confirmPassword = confirmPassword, !confirmPassword.isEmpty ,
              let password = password, !password.isEmpty else {
            return HGValidationResponse(warning: .isReuired, isValidate: false)
        }
        
        guard password == confirmPassword else{
            return HGValidationResponse(warning: .passwordsAreNotMatched, isValidate: false)
        }
        
        return HGValidationResponse(warning: nil, isValidate: true)
    }
}





