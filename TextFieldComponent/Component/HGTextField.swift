//
//  HGTextField.swift
//  TextFieldComponent
//
//  Created by hesham ghalaab on 5/15/19.
//  Copyright © 2019 hesham ghalaab. All rights reserved.
//

import UIKit

class HGTextField: UIView {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    @IBOutlet weak var topOfTextField: NSLayoutConstraint!
    @IBOutlet weak var topOfPlaceHolderLabel: NSLayoutConstraint!
    @IBOutlet weak var warningHeight: NSLayoutConstraint!
    
    weak var superView: UIView?
    private var isFirstTimeLayOutSuperView = true
    private var isFirstTimeAnimatePlaceHolder = true
    
    var fieldType = FieldType.other
    var hasWarning: Bool = false
    var warningText: String?{
        didSet{
            let width = warningLabel.frame.width
            guard let warningText = warningText else {
                hasWarning = false
                warningHeight.constant = 0
                separatorView.backgroundColor = separatorColor
                layOutSuperView()
                return
            }
            
            hasWarning = true
            warningLabel.text = warningText
            warningHeight.constant = heightOfLabel(withConstrainedWidth: width, font: warningLabel.font, value: warningText)
            separatorView.backgroundColor = warningTextColor
            layOutSuperView()
        }
    }
    
    var text: String?{
        didSet{
            guard let text = text else {
                self.animatePlaceHolderOut()
                return
            }
            
            self.animatePlaceHolderIn()
            textField.text = text
        }
    }
    
    private var placeHolderText: String = String(){
        didSet{ placeHolderLabel.text = placeHolderText }
    }
    private var placeHolderActiveColor: UIColor?
    private var placeHolderInActiveColor: UIColor?
    private var separatorColor = UIColor.lightGray
    private var warningTextColor = UIColor.red
    
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
    
    func setupTextField(text: String?, textFont: UIFont, textColor: UIColor){
        self.text = text
        self.textField.font = textFont
        self.textField.textColor = textColor
    }
    
    func setupWarningView(warningText: String?, warningFont: UIFont, warningTextColor: UIColor, separatorColor: UIColor = UIColor.lightGray){
        self.warningLabel.font = warningFont
        self.warningLabel.textColor = warningTextColor
        self.warningTextColor = warningTextColor
        self.separatorColor = separatorColor
        self.warningText = warningText
    }
    
    /// make sure to call this before setupTextField method.
    func setupPlaceHolderView(withPlaceHolderText text: String, Font font: UIFont, activeColor: UIColor, InActiveColor: UIColor){
        
        self.placeHolderLabel.font = font
        self.placeHolderActiveColor = activeColor
        self.placeHolderInActiveColor = InActiveColor
        self.placeHolderText = text
    }
    
    private func commonInit(){
        loadNib()
        textField.delegate = self
        initConstarint()
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
    
    private func initConstarint(){
        topOfTextField.constant = 0
        topOfPlaceHolderLabel.constant = (textField.frame.height / 2) - (placeHolderLabel.frame.height / 2)
    }
    
    func animatePlaceHolderIn(){
        topOfTextField.constant = placeHolderLabel.frame.height
        topOfPlaceHolderLabel.constant = 0
        
        guard !isFirstTimeAnimatePlaceHolder else {
            self.handlePlaceHolderAnimation(with: self.placeHolderActiveColor)
            self.isFirstTimeAnimatePlaceHolder = false
            return
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.handlePlaceHolderAnimation(with: self.placeHolderActiveColor)
        })
    }
    
    func animatePlaceHolderOut(){
        topOfTextField.constant = 0
        topOfPlaceHolderLabel.constant = (textField.frame.height / 2) - (placeHolderLabel.frame.height / 2)
        
        guard !isFirstTimeAnimatePlaceHolder else {
            self.handlePlaceHolderAnimation(with: self.placeHolderInActiveColor)
            self.isFirstTimeAnimatePlaceHolder = false
            return
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.handlePlaceHolderAnimation(with: self.placeHolderInActiveColor)
        })
    }
    
    private func handlePlaceHolderAnimation(with color: UIColor?){
        if let color = color{ self.placeHolderLabel.textColor = color }
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
    
    func heightOfLabel(withConstrainedWidth width: CGFloat, font: UIFont, value: String) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = value.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func isValidate() -> Bool{
        let response = Validation().validate(withValidationType: fieldType, value: textField.text)
        warningText = response.isValidate ? nil : response.warning
        return response.isValidate
    }
    
}

extension HGTextField: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing")
        animatePlaceHolderIn()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing")
        let _ = isValidate()
        guard let text = textField.text, !text.isEmpty else {
            animatePlaceHolderOut()
            return
        }
    }
}
