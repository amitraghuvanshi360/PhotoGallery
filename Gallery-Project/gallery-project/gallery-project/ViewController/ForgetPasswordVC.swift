//
//  ForgetPasswordVC.swift
//  gallery-project
//
//  Created by Ankush Sharma on 07/04/23.
//

import Foundation
import UIKit

protocol GetDataFromForgetPasswordProtocol: AnyObject {
    
    func getData(email: String)
}


class ForgetPasswordVC: BaseViewController{
    var isFieldShow: Bool = false
    var completionGetData: ( (String) -> Void )?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var resetPasswordBttn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.passwordView.layer.borderColor = ColorCode.defaultColor.cgColor
        self.passwordView.layer.borderWidth = 1
        self.passwordView.layer.cornerRadius = 20
        self.resetPasswordBttn.layer.cornerRadius = 20
    }
    
    
    
    //    MARK:
    @IBAction func sendOTPAction(_ sender: Any) {
        
        guard let emailId = self.emailTextField.text else{
            return
        }
        if !Validation.isValidEmailAddress(email: emailId){
            AlertController.CreateAlertMessage(title: Constant.error, message: Constant.enteredInvalidEmail, viewController: self)
            return
        }
        self.showActivityIndicator(titleMessage: Constant.isPendingMessage)
        DispatchQueue.global().async {
            
            APIManager.forgetPasswordRequestAPI(useremail: emailId, completion: { statusCode , errorMessage in
                DispatchQueue.main.async {
                    if statusCode == 200{
                        self.hideActivityIndicator()
                        AlertController.alertWithCompletionHandler(title: Constant.success, message: errorMessage, viewController: self) { [weak self] in
                            let moveToNextVC = self?.storyboard?.instantiateViewController(withIdentifier: "NewPasswordVC") as! NewPasswordVC
                            moveToNextVC.isHideShow = ((self?.isFieldShow) != false)
                        moveToNextVC.emailAddress = emailId
                            self?.navigationController?.pushViewController(moveToNextVC, animated: true)
                        }

                    }else{
                        self.hideActivityIndicator()
                        AlertController.CreateAlertMessage(title: Constant.success, message: errorMessage, viewController: self)
                    }
                }
            })
        }
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
