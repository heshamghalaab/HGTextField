//
//  ViewController.swift
//  TextFieldComponent
//
//  Created by hesham ghalaab on 5/15/19.
//  Copyright © 2019 hesham ghalaab. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: HGTextField!
    @IBOutlet weak var passwordTextField: HGTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let placeHolderFont = UIFont.boldSystemFont(ofSize: 16)
        let textFieldFont = UIFont.systemFont(ofSize: 16)
        let warningFont = UIFont.boldSystemFont(ofSize: 12)
        let activeColor = UIColor(red: 10/255, green: 111/255, blue: 127/255, alpha: 1)
        let inActiveColor = UIColor(red: 154/255, green: 152/255, blue: 153/255, alpha: 1)
        let warningColor = UIColor(red: 208/255, green: 2/255, blue: 27/255, alpha: 1)
        
        
        emailTextField.setup(withSuperView: self.view)
        emailTextField.setupPlaceHolderView(withText: "Email", font: placeHolderFont, activeColor: activeColor, InActiveColor: inActiveColor)
        emailTextField.setupTextField(text: nil, textFont: textFieldFont, textColor: .darkGray, textFieldType: .email)
        emailTextField.setupWarningView(warningText: nil, warningFont: warningFont, warningColor: warningColor, separatorColor: inActiveColor.withAlphaComponent(0.2))
        emailTextField.beginHandlingUI()
        
        passwordTextField.setup(withSuperView: self.view)
        passwordTextField.setupPlaceHolderView(withText: "Password", font: placeHolderFont, activeColor: activeColor, InActiveColor: inActiveColor)
        passwordTextField.setupTextField(text: nil, textFont: textFieldFont, textColor: .darkGray, textFieldType: .password)
        passwordTextField.setupWarningView(warningText: nil, warningFont: warningFont, warningColor: warningColor, separatorColor: inActiveColor.withAlphaComponent(0.2))
        passwordTextField.beginHandlingUI()
    }

    @IBAction func doneButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        let isEmailValidate = emailTextField.isValidate()
        let isPasswordValidate = passwordTextField.isValidate()
        print("isEmailValidate: \(isEmailValidate)")
        print("isPasswordValidate: \(isPasswordValidate)")
        
        print("Email is: \(emailTextField.getText() ?? "not set yet")")
        print("Password is: \(passwordTextField.getText() ?? "not set yet")")
    }
    
    @IBAction func onTapCancel(_ sender: UIButton) {
        self.view.endEditing(true)
    }
    
}
