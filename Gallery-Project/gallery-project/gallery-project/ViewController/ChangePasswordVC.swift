//
//  ChangePasswordVC.swift
//  gallery-project
//
//  Created by Ankush Sharma on 08/05/23.
//

import Foundation
import UIKit

class ChangePasswordVC:UIViewController{
    
    @IBOutlet private weak var emailView: UIView!
    @IBOutlet private weak var emailTextField: UITextField!
    
    @IBOutlet private weak var currentPassView: UIView!
    @IBOutlet private weak var currentPassField: UITextField!
    
    
    @IBOutlet private weak var newPasswordView: UIView!
    @IBOutlet private weak var newPassTextField: UITextField!
    
    @IBOutlet private weak var confirmPassView: UIView!
    @IBOutlet private weak var confirmPassField: UITextField!
    
    @IBOutlet private weak var changePassButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLayout()
        
    }
    @IBAction func changePasswordAction(_ sender: Any) {
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension ChangePasswordVC{
    func setLayout(){
        self.emailView.fieldLayoutStyle()
        self.currentPassView.fieldLayoutStyle()
        self.newPasswordView.fieldLayoutStyle()
        self.confirmPassView.fieldLayoutStyle()
        self.changePassButton.layer.cornerRadius = 20
    }
}
