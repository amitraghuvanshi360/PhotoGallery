//
//  LoginVC.swift
//  gallery-project
//
//  Created by Ankush Sharma on 07/04/23.
//

import Foundation
import UIKit

protocol ValidationProtocol {
    func validateEmail()
}


class LoginVC: BaseViewController {
    
    var isFieldShow: Bool = true
    //    MARK: - IBOutlets
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var continueButton: UIButton!
    @IBOutlet private weak var eyeButton: UIButton!
    @IBOutlet private weak var emailView: UIView!
    @IBOutlet private weak var passwordView: UIView!
    @IBOutlet private weak var signupButton: UIButton!
    
    @IBOutlet weak var forgetpasswordBtton: UIButton!
    
    //MARK: - View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.initialLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    //MARK: - IB Button Actions
    
    @IBAction func moveToSignup(_ sender: Any) {
        let vc =  self.storyboard?.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Forget password Action
    @IBAction func forgetPasswordAction(_ sender: Any) {
        let moveToNext = self.storyboard?.instantiateViewController(withIdentifier: "ForgetPasswordVC") as! ForgetPasswordVC
        self.navigationController?.pushViewController(moveToNext, animated: true)
    }
    
    //MARK: Password hide show Action
    @IBAction func passwordHideShowAction(_ sender: Any) {
        self.passwordViewAction()
    }
    
    
    @IBAction func LoginButtonAction(_ sender: Any) {
        
        let userEmail = self.emailTextField.text!
        let userPassword = self.passwordTextField.text!
        
        let error = Validation.validateInputData(useremail: userEmail , userpassword: userPassword)
        if !error.isEmpty{
            AlertController.CreateAlertMessage(title: Constant.error, message: error, viewController: self)
            return
        }

        self.showActivityIndicator(titleMessage: Constant.isPendingMessage)
        self.validateUserdetailsAPI(useremail: userEmail, password: userPassword)
    }
}


//    MARK: Layout styling
extension LoginVC{
    
    //    MARK: Set initial layout
    func initialLayout(){
        self.emailView.layer.cornerRadius = 20
        self.passwordView.layer.cornerRadius = 20
        self.emailView.layer.borderWidth = 1
        self.passwordView.layer.borderWidth = 1
        self.emailView.layer.borderColor = ColorCode.defaultColor.cgColor
        self.passwordView.layer.borderColor = ColorCode.defaultColor.cgColor
        self.continueButton.layer.cornerRadius = 20
        self.signupButton.layer.cornerRadius = 20
        
        //  forget button layout
        let yourAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 17, weight: .bold),
            .foregroundColor: UIColor.black,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let  attributeString = NSMutableAttributedString(
            string: "Forgot Password ?",
            attributes: yourAttributes
        )
        self.forgetpasswordBtton.setAttributedTitle(attributeString, for: .normal)
        
    }
    
    //    MARK: Password Visibility action
    func passwordViewAction(){
        if eyeButton.isSelected{
            self.passwordTextField.isSecureTextEntry = true
            self.eyeButton.setImage(UIImage(named: "hidden"), for: .normal)
            self.eyeButton.isSelected = false
        }else{
            self.passwordTextField.isSecureTextEntry = false
            self.eyeButton.setImage(UIImage(named: "view"), for: .normal)
            self.eyeButton.isSelected = true
        }
    }
} // extension end



extension LoginVC {
//    save data in user default
    func setUserDefaultsData(email: String , expiration: String , token: String){
        UserDefaults.standard.set(email as String, forKey: "useremail")
        UserDefaults.standard.set(token, forKey: "token")
        UserDefaults.standard.set(expiration, forKey: "expiration")
        UserDefaults.standard.object(forKey: "useremail")
        UserDefaults.standard.object(forKey: "token")
    }
    
    func validateUserdetailsAPI(useremail: String, password: String){
        DispatchQueue.global().async {
            APIManager.LoginRequestAPI(useremail: useremail, userpassword: password){ userModelData, errorMessage  in
                DispatchQueue.main.async {
                    guard let unwappedData = userModelData else {
                        return
                    }
                    if unwappedData.statusCode == 200 {
                        if let innerData = unwappedData.data {
                            self.setUserDefaultsData(email: innerData.email, expiration: innerData.expiration, token: innerData.token)
                            self.hideActivityIndicator()
                            AlertController.alertWithCompletionHandler(title: Constant.success, message: errorMessage, viewController: self) { [self] in
                                let viewController =  self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                                self.navigationController?.pushViewController(viewController, animated: true)
                            }
                        }
                    }else if unwappedData.statusCode == 202{
                        self.hideActivityIndicator()
                        AlertController.alertWithCompletionHandler(title: Constant.error, message: unwappedData.message, viewController: self, completionOnOkButton: {
                            let viewController =  self.storyboard?.instantiateViewController(withIdentifier: "NewPasswordVC") as! NewPasswordVC
                            viewController.isHideShow = ((self.isFieldShow) != false)
                            viewController.emailAddress = useremail
                            self.navigationController?.pushViewController(viewController, animated: true)
                            
                        })
                    }else {
                        self.hideActivityIndicator()
                        AlertController.CreateAlertMessage(title: Constant.error, message: errorMessage, viewController: self)
                    }
                }
            }
        }
    }
}
