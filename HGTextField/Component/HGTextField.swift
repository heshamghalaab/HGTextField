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
    
    @IBOutlet weak private var topOfTextField: NSLayoutConstraint!
    @IBOutlet weak private var topOfPlaceHolderLabel: NSLayoutConstraint!
    @IBOutlet weak private var leadingOfPlaceHolderLabel: NSLayoutConstraint!
    @IBOutlet weak private var warningHeight: NSLayoutConstraint!
    
    weak private var superView: UIView?
    private var isFirstTimeLayOutSuperView = true
    private var isFirstTimeAnimatePlaceHolder = true
    
    private var text: String?
    private var textColor = UIColor.red
    private var textFont = UIFont()
    private var textFieldType = FieldType.other
    
    private var placeHolderText = String()
    private var placeHolderFont = UIFont()
    private var placeHolderActiveColor = UIColor()
    private var placeHolderInActiveColor = UIColor()
    
    private var separatorColor = UIColor.lightGray
    
    private var warningText: String?
    private var warningColor = UIColor.red
    private var warningFont = UIFont()
    var hasWarning: Bool = false
    
    /// the padding between the text field and the placeHolder Label.
    private let padding: CGFloat = 2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func setup(withSuperView superView: UIView?){
        self.superView = superView
    }
    
    func setupTextField(text: String?, textFont: UIFont, textColor: UIColor, textFieldType: FieldType){
        self.text = text
        self.textFont = textFont
        self.textColor = textColor
        self.textFieldType = textFieldType
    }
    
    func setupWarningView(warningText: String?, warningFont: UIFont, warningColor: UIColor, separatorColor: UIColor = UIColor.lightGray){
        self.warningText = warningText
        self.warningFont = warningFont
        self.warningColor = warningColor
        self.separatorColor = separatorColor
    }
    
    /// make sure to call this before setupTextField method.
    func setupPlaceHolderView(withText text: String, font: UIFont, activeColor: UIColor, InActiveColor: UIColor){
        self.placeHolderText = text
        self.placeHolderFont = font
        self.placeHolderActiveColor = activeColor
        self.placeHolderInActiveColor = InActiveColor
    }
    
    func beginHandlingUI(){
        beginHandlingPlaceHolderUI()
        beginHandlingWarningUI()
        beginHandlingTextUI()
        
        setText(with: self.text)
        setWarningText(with: self.warningText)
        self.isHidden = false
    }
    
    func setText(with text: String?){
        self.text = text
        
        guard let text = text else {
            self.inActivePlaceHolderAnimation()
            return
        }
        
        self.activePlaceHolderAnimation()
        textField.text = text
    }
    
    func getText() -> String?{
        return self.text
    }
    
    func setWarningText(with warningText: String?){
        self.warningText = warningText
        
        guard let warningText = warningText else {
            hasWarning = false
            warningHeight.constant = 0
            separatorView.backgroundColor = separatorColor
            layOutSuperView()
            return
        }
        
        let width = warningLabel.frame.width
        hasWarning = true
        warningLabel.text = warningText
        warningHeight.constant = height(withWidth: width, font: warningLabel.font, value: warningText)
        separatorView.backgroundColor = warningColor
        layOutSuperView()
    }
    
    private func beginHandlingPlaceHolderUI(){
        placeHolderLabel.text = placeHolderText
    }
    
    private func beginHandlingTextUI(){
        textField.font = textFont
        textField.textColor = textColor
        textField.tintColor = placeHolderActiveColor
    }
    
    private func beginHandlingWarningUI(){
        warningLabel.font = warningFont
        warningLabel.textColor = warningColor
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
    
    private func activePlaceHolderAnimation(){
        let placeHolderHight = height(withWidth: placeHolderLabel.frame.width, font: placeHolderFont, value: placeHolderText)
        topOfTextField.constant = placeHolderHight + padding
        topOfPlaceHolderLabel.constant = 0
        
        guard !isFirstTimeAnimatePlaceHolder else {
            self.animatePlaceHolder(with: self.placeHolderActiveColor, font: placeHolderFont,
                                    transform: CGAffineTransform(scaleX: 1, y: 1), leading: 0)
            self.isFirstTimeAnimatePlaceHolder = false
            return
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.animatePlaceHolder(with: self.placeHolderActiveColor, font: self.placeHolderFont,
                                    transform: CGAffineTransform(scaleX: 1, y: 1), leading: 0)
        })
    }
    
    private func inActivePlaceHolderAnimation(){
        let textHight = height(withWidth: textField.frame.width, font: textFont, value: text ?? "")
        let placeHolderHight = height(withWidth: placeHolderLabel.frame.width, font: placeHolderFont, value: placeHolderText)
        topOfTextField.constant =  padding
        topOfPlaceHolderLabel.constant = (textHight / 2) - (placeHolderHight / 2)
        
        guard !isFirstTimeAnimatePlaceHolder else {
            self.animatePlaceHolder(with: self.placeHolderInActiveColor, font: placeHolderFont,
                                    transform: CGAffineTransform(scaleX: 0.925, y: 0.925), leading: -14)
            self.isFirstTimeAnimatePlaceHolder = false
            return
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.animatePlaceHolder(with: self.placeHolderInActiveColor, font: self.placeHolderFont,
                                    transform: CGAffineTransform(scaleX: 0.925, y: 0.925), leading: -14)
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
        let warningText = response.isValidate ? nil : response.warning
        setWarningText(with: warningText)
        return response.isValidate
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
