//
//  TextField.swift
//  TextFieldComponent
//
//  Created by hesham ghalaab on 5/15/19.
//  Copyright © 2019 hesham ghalaab. All rights reserved.
//

import UIKit

class TextField: UIView {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    @IBOutlet weak var topOfTextField: NSLayoutConstraint!
    @IBOutlet weak var topOfPlaceHolderLabel: NSLayoutConstraint!
    @IBOutlet weak var warningHeight: NSLayoutConstraint!
    
    weak var superView: UIView?
    var fieldType = FieldType.other
    
    var hasWarning: Bool = false
    var warningText: String?{
        didSet{
            let width = warningLabel.frame.width
            guard let warningText = warningText else {
                warningHeight.constant = 0
                layOutSuperView()
                hasWarning = false
                return
            }
            hasWarning = true
            warningLabel.text = warningText
            warningHeight.constant = heightOfLabel(withConstrainedWidth: width, font: warningLabel.font, value: warningText)
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
    
    var placeHolderText: String = String(){
        didSet{
            placeHolderLabel.text = placeHolderText
        }
    }
    
    private var placeHolderPrimaryColor: UIColor?{
        didSet{
            guard let color = placeHolderPrimaryColor else {return}
            guard text == nil else { return }
            self.placeHolderLabel.textColor = color
        }
    }
    
    private var placeHolderSecondaryColor: UIColor?{
        didSet{
            guard let color = placeHolderSecondaryColor else {return}
            guard text != nil else { return }
            self.placeHolderLabel.textColor = color
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func setup(withSuperView superView: UIView?, separatorColor: UIColor = UIColor.lightGray ,text: String?, placeHolderText: String){
        self.superView = superView
        self.separatorView.backgroundColor = separatorColor
        self.placeHolderText = placeHolderText
        self.text = text
    }
    
    func setupWarningView(warningText: String?, warningFont: UIFont, warningTextColor: UIColor){
        self.warningLabel.font = warningFont
        self.warningLabel.textColor = warningTextColor
        self.warningText = warningText
    }
    
    func setupPlaceHolderView(withFont font: UIFont, primaryColor: UIColor, secondaryColor: UIColor){
        self.placeHolderLabel.font = font
        self.placeHolderPrimaryColor = primaryColor
        self.placeHolderSecondaryColor = secondaryColor
    }
    
    private func commonInit(){
        loadNib()
        textField.delegate = self
        initConstarint()
    }
    
    private func loadNib(){
        Bundle.main.loadNibNamed("TextField", owner: self, options: nil)
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
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            if let color = self.placeHolderSecondaryColor{
                self.placeHolderLabel.textColor = color
            }
            self.superView?.layoutIfNeeded()
        })
    }
    
    func animatePlaceHolderOut(){
        topOfTextField.constant = 0
        topOfPlaceHolderLabel.constant = (textField.frame.height / 2) - (placeHolderLabel.frame.height / 2)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            if let color = self.placeHolderPrimaryColor{
                self.placeHolderLabel.textColor = color
            }
            self.superView?.layoutIfNeeded()
        })
    }
    
    private func layOutSuperView(){
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

extension TextField: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing")
        animatePlaceHolderIn()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing")
        guard let text = textField.text, !text.isEmpty else {
            animatePlaceHolderOut()
            return
        }
    }
}
