//
//  NewPasswordVC.swift
//  gallery-project
//
//  Created by Ankush Sharma on 07/04/23.
//

import Foundation
import UIKit

class NewPasswordVC: BaseViewController{
//  MARK:  Global variables
    
    var isHideShow:Bool = false
    var emailAddress:String = ""
    //   MARK: IB outlets
    @IBOutlet private weak var buttonHeight: NSLayoutConstraint!
    @IBOutlet private weak var fieldStackVw: UIStackView!
    @IBOutlet private weak var passwordView: UIView!
    @IBOutlet private weak var confirmPasswordView: UIView!
    
    @IBOutlet private weak var verifyOtpButton: UIButton!
    @IBOutlet private weak var newpasswordField: UITextField!
    @IBOutlet private weak var confirmPassField: UITextField!
    @IBOutlet private weak var submitBttn: UIButton!
    @IBOutlet private weak var eyeButton1: UIButton!
    @IBOutlet private weak var eyeButton2: UIButton!
    
    @IBOutlet private weak var otpIndex1: UITextField!
    @IBOutlet private weak var otpIndex2: UITextField!
    @IBOutlet private weak var otpIndex3: UITextField!
    @IBOutlet private weak var otpIndex4: UITextField!
    @IBOutlet private weak var otpIndex5: UITextField!
    @IBOutlet private weak var otpIndex6: UITextField!
    @IBOutlet weak var resendOtpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.checkFieldShouldHideOrShow()
        self.initLayout()
        self.addTargetForTextField()
       
    }
    //MARK: back to previous activity
    @IBAction func backActionButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //   MARK: Password visibility action
    @IBAction func createPasswordVisibilityAction(_ sender: Any) {
        self.passwordViewAction(eyebutton: self.eyeButton1, textField: self.newpasswordField)
    }
    
    @IBAction func confirmPasswordVisibilityAction(_ sender: Any) {
        self.passwordViewAction(eyebutton: self.eyeButton2, textField: self.confirmPassField)
    }
    
    @IBAction func resendOtpAction(_ sender: Any) {
        self.resendOTP(email: emailAddress)
    }
    //    MARK: Submit button action for new password creation
    @IBAction func submitButtonAction(_ sender: Any) {
        let newpass = self.newpasswordField.text
        let confpass = self.confirmPassField.text
        let otp1 = self.otpIndex1.text
        let otp2 = self.otpIndex2.text
        let otp3 = self.otpIndex3.text
        let otp4 = self.otpIndex4.text
        let otp5 = self.otpIndex5.text
        let otp6 = self.otpIndex6.text
        guard let firstIndex = otp1 , let  secondIndex = otp2 ,let thirdIndex = otp3, let fourthIndex = otp4, let fifthIndex = otp5,let  sixthIndex = otp6 , let newpassword = newpass , let confirmpassword = confpass else {
            return
        }
        var errorMessage = Validation.isNewPasswordValid(newPassword: newpassword, confirmpPassword: confirmpassword)
        let otpError = Validation.isOtpValid(index1: firstIndex, index2: secondIndex, index3: thirdIndex, index4: fourthIndex, index5: fifthIndex, index6: sixthIndex)
        
        if !otpError.isEmpty {
            AlertController.CreateAlertMessage(title: Constant.error, message: otpError, viewController: self)
        }else if(!errorMessage.isEmpty){
            AlertController.CreateAlertMessage(title: Constant.error, message: errorMessage, viewController: self)
        }
        
        let enteredOTP = [firstIndex , secondIndex , thirdIndex, fourthIndex , fifthIndex, sixthIndex].joined()
        self.createNewPassword(useremail: emailAddress, newpassword: newpassword, confirmpassword: confirmpassword, otp: enteredOTP)
        
    }
//    MARK: Verify otp button Action
    @IBAction func verifyOTPAction(_ sender: Any) {
        let otp1 = self.otpIndex1.text
        let otp2 = self.otpIndex2.text
        let otp3 = self.otpIndex3.text
        let otp4 = self.otpIndex4.text
        let otp5 = self.otpIndex5.text
        let otp6 = self.otpIndex6.text
        if let firstIndex = otp1 , let  secondIndex = otp2 ,let thirdIndex = otp3, let fourthIndex = otp4, let fifthIndex = otp5,let  sixthIndex = otp6{
            let error = Validation.isOtpValid(index1: firstIndex, index2: secondIndex, index3: thirdIndex, index4: fourthIndex, index5: firstIndex, index6: sixthIndex)
            
            if !error.isEmpty{
                AlertController.CreateAlertMessage(title: Constant.error, message: error, viewController: self)
            }
            let enteredOTP = [firstIndex , secondIndex , thirdIndex , fourthIndex , fifthIndex , sixthIndex].joined()
            self.verifyOtpRequest(otp: enteredOTP)
            
        }
    }
}


extension NewPasswordVC{
    func verifyOtpRequest(otp:String){
        DispatchQueue.global().async { [self] in
            APIManager.confirmRegistrationAPI(email: emailAddress, otp: otp, completion: { data in
                guard let unwrapData = data else {
                    return
                }
                DispatchQueue.main.async {
                    if unwrapData.statusCode == 200 {
                        AlertController.alertWithCompletionHandler(title: Constant.success, message: unwrapData.message, viewController: self, completionOnOkButton: {
                            let moveToNext = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                            self.navigationController?.pushViewController(moveToNext, animated: true)
                        })
                    }
                    else{
                        AlertController.CreateAlertMessage(title: Constant.error, message: unwrapData.message, viewController: self)
                    }
                }
            })
        }
    }
    
    
    func createNewPassword(useremail: String,newpassword: String  ,confirmpassword: String , otp: String){
        DispatchQueue.global().async {
            APIManager.setNewPassword(useremail: useremail, newpassword: confirmpassword, confirmPassword: newpassword,otp: otp, completion: { (statusCode, errorMessage) in
                DispatchQueue.main.async {
                    if statusCode == 200 {
                        AlertController.alertWithCompletionHandler(title: Constant.success, message: errorMessage, viewController: self, completionOnOkButton: {
                            let moveToNext = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                            self.navigationController?.pushViewController(moveToNext, animated: true)
                        })
                    }
                    else{
                        AlertController.CreateAlertMessage(title: Constant.error, message: errorMessage, viewController: self)
                    }
                }
            })
        }
    }
    
    func resendOTP(email: String){
        APIManager.forgetPasswordRequestAPI(useremail: email, completion: { statusCode , errorMessage in
            DispatchQueue.main.async {
                if statusCode == 200{
                    AlertController.alertWithCompletionHandler(title: Constant.success, message: Constant.optResendMessage, viewController: self) { [self] in
                    }
                }else{
                    AlertController.CreateAlertMessage(title: Constant.error, message: errorMessage, viewController: self)
                }
            }
        })
    }
}
extension NewPasswordVC{
    //      MARK:   Setup field layout and styling
    func initLayout(){
        // view
        self.setViewlayout(view: self.passwordView)
        self.setViewlayout(view: self.confirmPasswordView)
        
        // button
        self.setButtonLayout(button: self.submitBttn)
        self.setButtonLayout(button: self.verifyOtpButton)
        
        // otp fields
        self.otpFieldLayout(textField: otpIndex1)
        self.otpFieldLayout(textField: otpIndex2)
        self.otpFieldLayout(textField: otpIndex3)
        self.otpFieldLayout(textField: otpIndex4)
        self.otpFieldLayout(textField: otpIndex5)
        self.otpFieldLayout(textField: otpIndex6)

        let yourAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 17, weight: .bold),
            .foregroundColor: UIColor.black,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let  attributeString = NSMutableAttributedString(
            string: "Resend Otp ?",
            attributes: yourAttributes
        )
        self.resendOtpButton.setAttributedTitle(attributeString, for: .normal)
        
    } // function end
 
    //   MARK: otp textfield target action to move next fields
    func addTargetForTextField(){
        otpIndex1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otpIndex2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otpIndex3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otpIndex4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otpIndex5.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otpIndex6.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
    }
    
    //   MARK: Password Visibility action
    func passwordViewAction(eyebutton : UIButton , textField: UITextField){
        if eyebutton.isSelected{
            textField.isSecureTextEntry = true
            eyebutton.setImage(UIImage(named: "hidden"), for: .normal)
            eyebutton.isSelected = false
        }else{
            textField.isSecureTextEntry = false
            eyebutton.setImage(UIImage(named: "view"), for: .normal)
            eyebutton.isSelected = true
        }
    }
    
    // checking for max length otp field
    @objc func textFieldDidChange(textField: UITextField){
        var text = textField.text
            if  text?.count == 1 {
                switch textField{
                case otpIndex1:
                    otpIndex2.becomeFirstResponder()
                case otpIndex2:
                    otpIndex3.becomeFirstResponder()
                case otpIndex3:
                    otpIndex4.becomeFirstResponder()
                case otpIndex4:
                    otpIndex5.becomeFirstResponder()
                case otpIndex5:
                    otpIndex6.becomeFirstResponder()
                case otpIndex6:
                    otpIndex6.resignFirstResponder()
                default:
                    break
                }
            }
        if text?.count ?? 1 > 1{
            textField.text = ""
        }
        }
    
} // extension end


extension NewPasswordVC{
    //    Check field should hide or show
    func checkFieldShouldHideOrShow(){
        self.fieldStackVw.isHidden = self.isHideShow
        self.verifyOtpButton.isHidden = !self.isHideShow
        //        if self.isHideShow{
        //            self.buttonHeight.constant = 45
        //        }else{
        //            self.buttonHeight.constant = 0
        //        }
        self.buttonHeight.constant =  self.isHideShow ? 45 : 0
    }
    
    //      setup view styling
    func setViewlayout(view:  UIView){
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 25
        view.layer.borderColor = ColorCode.defaultColor.cgColor
    }
   
    //    setup button styling
    func setButtonLayout(button: UIButton){
        button.layer.cornerRadius = 25
    }
   
    //   setup textfield styling
    func otpFieldLayout(textField: UITextField){
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
    }
}
