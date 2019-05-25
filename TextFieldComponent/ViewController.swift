//
//  ViewController.swift
//  TextFieldComponent
//
//  Created by hesham ghalaab on 5/15/19.
//  Copyright © 2019 hesham ghalaab. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textFont = UIFont.systemFont(ofSize: 17)
        let warningFont = UIFont.systemFont(ofSize: 12)
        let inActiveColor = UIColor.lightGray
        let activeColor = UIColor(red: 4/255, green: 124/255, blue: 255/255, alpha: 1)
        
        emailTextField.setup(withSuperView: self.view, separatorColor: .lightGray, text: nil, placeHolderText: "Email")
        emailTextField.setupPlaceHolderView(withFont: textFont, primaryColor: inActiveColor, secondaryColor: activeColor)
        emailTextField.setupWarningView(warningText: nil, warningFont: warningFont, warningTextColor: .red)
        emailTextField.fieldType = .email
        
        passwordTextField.setup(withSuperView: self.view, separatorColor: .lightGray, text: nil, placeHolderText: "Password")
        passwordTextField.setupPlaceHolderView(withFont: textFont, primaryColor: inActiveColor, secondaryColor: activeColor)
        passwordTextField.setupWarningView(warningText: nil, warningFont: warningFont, warningTextColor: .red)
        passwordTextField.fieldType = .password
    }

    @IBAction func doneButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        let isEmailValidate = emailTextField.isValidate()
        let isPasswordValidate = passwordTextField.isValidate()
        print("isEmailValidate: \(isEmailValidate)")
        print("isPasswordValidate: \(isPasswordValidate)")
    }
}
