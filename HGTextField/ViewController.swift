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
        
        var emailPlaceHolderPackage = HGPlaceHolderPackage.init()
        emailPlaceHolderPackage.text = "Email"
        emailTextField.setup(withSuperView: self.view)
        emailTextField.configuration(with: .email, isMandatory: true)
        emailTextField.setupTextField(with: HGFieldPackage.init())
        emailTextField.setupPlaceHolderView(with: emailPlaceHolderPackage)
        emailTextField.setupWarningView(with: HGWarningPackage.init())
        emailTextField.setupSeparator(with: HGSeparatorPackage.init())
        emailTextField.beginHandlingUI()
        
        var passwordPlaceHolderPackage = HGPlaceHolderPackage.init()
        passwordPlaceHolderPackage.text = "Password"
        passwordTextField.setup(withSuperView: self.view)
        passwordTextField.configuration(with: .password, isMandatory: true)
        passwordTextField.setupTextField(with: HGFieldPackage.init())
        passwordTextField.setupPlaceHolderView(with: passwordPlaceHolderPackage)
        passwordTextField.setupWarningView(with: HGWarningPackage.init())
        passwordTextField.setupSeparator(with: HGSeparatorPackage.init())
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
