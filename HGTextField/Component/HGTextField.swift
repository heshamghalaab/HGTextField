//
//  HGTextField.swift
//  TextFieldComponent
//
//  Created by hesham ghalaab on 5/15/19.
//  Copyright © 2019 hesham ghalaab. All rights reserved.
//

import UIKit

class HGTextField: UIView {

    @IBOutlet weak private var mainView: UIView!
    @IBOutlet weak private var textField: UITextField!
    @IBOutlet weak private var placeHolderLabel: UILabel!
    @IBOutlet weak private var warningLabel: UILabel!
    @IBOutlet weak private var separatorView: UIView!
    
    @IBOutlet weak var showHideButton: UIButton!
    @IBOutlet weak private var topOfTextField: NSLayoutConstraint!
    @IBOutlet weak private var topOfPlaceHolderLabel: NSLayoutConstraint!
    @IBOutlet weak private var leadingOfPlaceHolderLabel: NSLayoutConstraint!
    @IBOutlet weak private var warningHeight: NSLayoutConstraint!
    @IBOutlet weak private var trailingOfTextField: NSLayoutConstraint!
    
    /// the padding between the text field and the placeHolder Label.
    private let padding: CGFloat = 2
    
    weak private var superView: UIView?
    private var isFirstTimeLayOutSuperView = true
    private var isFirstTimeAnimatePlaceHolder = true
    
    private var fieldPackage = HGFieldPackage()
    private var placeHolderPackage = HGPlaceHolderPackage()
    private var separatorPackage = HGSeparatorPackage()
    private var warningPackage = HGWarningPackage()
    
    var hasWarning: Bool = false
    var status = HGTextFieldStatus.inActive { didSet { handlingSeparatorView() } }
    private var textFieldType = FieldType.other
    private var isMandatory = true
    private var haveShowPassword = false
    private var isSecureTextEntry = false
    private var keyboardType = UIKeyboardType.default
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        loadNib()
        textField.delegate = self
        self.isHidden = true
    }
    
    private func loadNib(){
        Bundle.main.loadNibNamed("HGTextField", owner: self, options: nil)
        addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainView.topAnchor.constraint(equalTo: self.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: self.bottomAnchor)])
    }
    
    func setup(withSuperView superView: UIView?){
        self.superView = superView
    }
    
    func configuration(with textFieldType: FieldType, isMandatory: Bool, keyboardType: UIKeyboardType = .default){
        self.textFieldType = textFieldType
        self.isMandatory = isMandatory
        self.keyboardType = keyboardType
    }
    
    /// call this method only if it needed,
    func configure(isSecureTextEntry: Bool, haveShowPassword: Bool){
        self.isSecureTextEntry = isSecureTextEntry
        self.haveShowPassword = haveShowPassword
    }
    
    func setupTextField(with fieldPackage: HGFieldPackage){
        self.fieldPackage = fieldPackage
    }
    
    func setupWarningView(with warningPackage: HGWarningPackage){
        self.warningPackage = warningPackage
    }
    
    func setupPlaceHolderView(with placeHolderPackage: HGPlaceHolderPackage){
        self.placeHolderPackage = placeHolderPackage
    }
    
    func setupSeparator(with separatorPackage: HGSeparatorPackage){
        self.separatorPackage = separatorPackage
    }
    
    func beginHandlingUI(){
        beginHandlingPlaceHolderUI()
        beginHandlingWarningUI()
        beginHandlingTextUI()
        beginHandlingShowHideUI()
        
        setText(with: self.fieldPackage.text)
        setWarningText(with: self.warningPackage.warningText)
        self.isHidden = false
    }
    
    private func beginHandlingPlaceHolderUI(){
        placeHolderLabel.text = placeHolderPackage.text
    }
    
    private func beginHandlingTextUI(){
        textField.font = fieldPackage.textFont
        textField.textColor = fieldPackage.textColor
        textField.tintColor = placeHolderPackage.activeColor
        textField.keyboardType = keyboardType
    }
    
    private func beginHandlingWarningUI(){
        warningLabel.font = warningPackage.warningFont
        warningLabel.textColor = warningPackage.warningColor
    }
    
    private func beginHandlingShowHideUI(){
        textField.isSecureTextEntry = isSecureTextEntry
        showHideButton.isHidden = !haveShowPassword
        trailingOfTextField.constant = haveShowPassword ? showHideButton.frame.width : 0
        let newIconName = textField.isSecureTextEntry ? "showIcon" : "hideIcon"
        showHideButton.setImage(UIImage(named: newIconName), for: .normal)
    }
    
    func setText(with text: String?){
        self.fieldPackage.text = text
        self.handlingSeparatorView()
        
        guard let text = text else {
            self.inActivePlaceHolderAnimation()
            return
        }
        
        self.activePlaceHolderAnimation()
        textField.text = text
    }
    
    func getText() -> String?{
        return self.fieldPackage.text
    }
    
    func setWarningText(with warningText: String?){
        self.warningPackage.warningText = warningText
        
        guard let warningText = warningText else {
            hasWarning = false
            handlingSeparatorView()
            warningHeight.constant = 0
            layOutSuperView()
            return
        }
        
        let width = warningLabel.frame.width
        hasWarning = true
        handlingSeparatorView()
        warningLabel.text = warningText
        warningHeight.constant = height(withWidth: width, font: warningLabel.font, value: warningText)
        layOutSuperView()
    }
    
    private func handleStatus(with newStatus: HGTextFieldStatus){
        self.status = newStatus
    }
    
    private func handlingSeparatorView(){
        guard !hasWarning else{
            self.separatorView.backgroundColor = self.separatorPackage.atWarningColor
            return
        }
        
        switch self.status {
        case .active: self.separatorView.backgroundColor = self.separatorPackage.activeColor
        case .inActive: self.separatorView.backgroundColor = self.separatorPackage.inActiveColor
        }
    }
    
    private func activePlaceHolderAnimation(){
        let placeHolderHight = height(withWidth: placeHolderLabel.frame.width,
                                      font: placeHolderPackage.font,
                                      value: placeHolderPackage.text)
        topOfTextField.constant = placeHolderHight + padding
        topOfPlaceHolderLabel.constant = 0
        handleStatus(with: .active)
        
        guard !isFirstTimeAnimatePlaceHolder else {
            self.animatePlaceHolder(with: self.placeHolderPackage.activeColor,
                                    font: placeHolderPackage.font,
                                    transform: CGAffineTransform(scaleX: 1, y: 1), leading: 0)
            self.isFirstTimeAnimatePlaceHolder = false
            return
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.animatePlaceHolder(with: self.placeHolderPackage.activeColor,
                                    font: self.placeHolderPackage.font,
                                    transform: CGAffineTransform(scaleX: 1, y: 1), leading: 0)
        })
    }
    
    private func inActivePlaceHolderAnimation(){
        let textHight = height(withWidth: textField.frame.width,
                               font: fieldPackage.textFont,
                               value: fieldPackage.text ?? "")
        let placeHolderHight = height(withWidth: placeHolderLabel.frame.width,
                                      font: placeHolderPackage.font,
                                      value: placeHolderPackage.text)
        topOfTextField.constant =  padding
        topOfPlaceHolderLabel.constant = (textHight / 2) - (placeHolderHight / 2)
        handleStatus(with: .inActive)
        
        guard !isFirstTimeAnimatePlaceHolder else {
            self.animatePlaceHolder(with: placeHolderPackage.InActiveColor,
                                    font: placeHolderPackage.font,
                                    transform: CGAffineTransform(scaleX: 0.925, y: 0.925),
                                    leading: -14)
            self.isFirstTimeAnimatePlaceHolder = false
            return
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.animatePlaceHolder(with: self.placeHolderPackage.InActiveColor,
                                    font: self.placeHolderPackage.font,
                                    transform: CGAffineTransform(scaleX: 0.925, y: 0.925),
                                    leading: -14)
        })
    }
    
    private func animatePlaceHolder(with color: UIColor, font: UIFont, transform: CGAffineTransform, leading: CGFloat){
        self.placeHolderLabel.textColor = color
        self.placeHolderLabel.font = font
        self.placeHolderLabel.transform = transform
        self.leadingOfPlaceHolderLabel.constant = leading
        self.superView?.layoutIfNeeded()
    }
    
    private func layOutSuperView(){
        guard !isFirstTimeLayOutSuperView else {
            self.superView?.layoutIfNeeded()
            self.isFirstTimeLayOutSuperView = false
            return
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.superView?.layoutIfNeeded()
        })
    }
    
    private func height(withWidth width: CGFloat, font: UIFont, value: String) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = value.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func isValidate() -> Bool{
        let response = Validation().validate(withValidationType: textFieldType, value: textField.text)
        let warning = response.isValidate ? nil : response.warning
        
        if let warning = warning{
            // check if the warning = .isReuired and already the field is configured as not a mendatory
            // so it should not make any warning.
            if warning == .isReuired , !self.isMandatory{
                setWarningText(with: nil)
                return true
            }
        }
        
        setWarningText(with: warning?.rawValue)
        return response.isValidate
    }
    
    @IBAction func onTapShowHide(_ sender: UIButton) {
        textField.isSecureTextEntry.toggle()
        let newIconName = textField.isSecureTextEntry ? "showIcon" : "hideIcon"
        showHideButton.setImage(UIImage(named: newIconName), for: .normal)
    }
    
}

extension HGTextField: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activePlaceHolderAnimation()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let _ = isValidate()
        guard let text = textField.text, !text.isEmpty else {
            inActivePlaceHolderAnimation()
            return
        }
    }
}
