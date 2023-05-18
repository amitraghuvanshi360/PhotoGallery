//
//  ChangePasswordVC.swift
//  gallery-project
//
//  Created by Ankush Sharma on 08/05/23.
//

import Foundation
import UIKit

class ChangePasswordVC:BaseViewController{
    
    //MARK:   IBOutlets and variable declarations
    @IBOutlet private weak var emailView: UIView!
    @IBOutlet private weak var emailTextField: UITextField!
    
    @IBOutlet private weak var currentPassView: UIView!
    @IBOutlet private weak var currentPassField: UITextField!
    
    @IBOutlet private weak var newPasswordView: UIView!
    @IBOutlet private weak var newPassTextField: UITextField!
    
    @IBOutlet private weak var confirmPassView: UIView!
    @IBOutlet private weak var confirmPassField: UITextField!
    
    @IBOutlet private weak var changePassButton: UIButton!
    
    //    MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLayout() // setup initial layout
        
    }
    
    //    MARK: Change Password Action Button
    @IBAction func changePasswordAction(_ sender: Any) {
        print("button pressed")
        let savedEmail = UserDefaults.standard.object(forKey: "email")
        let userEmail = self.emailTextField.text
        let currentPass = self.currentPassField.text
        let newPass = self.newPassTextField.text
        let confPass = self.confirmPassField.text
        
        guard let email = userEmail, let currentPassword = currentPass , let newPassword = newPass , let confirmPassword = confPass else {
            return
        }
        
        var error = Validation.validateInputData(useremail: email , userpassword: currentPassword)
        if !error.isEmpty{
            AlertController.CreateAlertMessage(title: Constant.error, message: error, viewController: self)
            return
        }
        self.showActivityIndicator(titleMessage: Constant.isPendingMessage)
        self.changePasswordAPI(email: email, currentPassword: currentPassword, newPassword: newPassword, confirmPassword: confirmPassword)
        
    }
    
    //    MARK: Back Button Action
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


// MARK: Initials layout and api callls
extension ChangePasswordVC{
    func setLayout(){
        self.emailView.fieldLayoutStyle()
        self.currentPassView.fieldLayoutStyle()
        self.newPasswordView.fieldLayoutStyle()
        self.confirmPassView.fieldLayoutStyle()
        self.changePassButton.layer.cornerRadius = 20
    }
    
    func changePasswordAPI(email:String, currentPassword:String , newPassword:String , confirmPassword:String){
        DispatchQueue.global().async { [self] in
            APIManager.changePasswordRequestAPI(email: email, currentPassword: currentPassword, newPassword: newPassword, confirmPassword: confirmPassword, completion: { dataObj in
                DispatchQueue.main.async {
                    if dataObj.statusCode == 200{
                        self.hideActivityIndicator()
                        AlertController.alertWithCompletionHandler(title: Constant.success, message: dataObj.message, viewController: self, completionOnOkButton: {
                            print(dataObj.message)
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                            self.navigationController?.pushViewController(vc, animated: true)
                        })
                    }else if(dataObj.statusCode == 400){
                        self.hideActivityIndicator()
                        AlertController.alertWithCompletionHandler(title: Constant.failure, message: dataObj.message, viewController: self, completionOnOkButton: {
                            print(dataObj.message)
                        })
                    }else{
                        self.hideActivityIndicator()
                        AlertController.CreateAlertMessage(title: Constant.error, message: Constant.isInvalid, viewController: self)
                    }
                }
            })
        }
    }
}
