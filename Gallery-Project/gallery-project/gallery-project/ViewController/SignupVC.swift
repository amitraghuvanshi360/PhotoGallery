//
//  SignupVC.swift
//  gallery-project
//
//  Created by Ankush Sharma on 10/04/23.
//

import Foundation
import UIKit
import iOSDropDown

class SignupVC: BaseViewController, UINavigationControllerDelegate {
//    MARK: IBOutlets and variable declaration
    
    private var country: Country?
    var countryData = [String]()
    var isFieldShow: Bool = true
    let picker = UIImagePickerController()
    var pickerImageData:[UIImage] = []
    var hobbyIndex:Int?
    var selectedCountry: String = ""
    var selectedGender: String = ""
    @IBOutlet private weak var profileView: UIView!
    @IBOutlet private weak var pickProfileImage: UIImageView!
    
    @IBOutlet private weak var nameView: UIView!
    @IBOutlet private weak var nameTextField: UITextField!
    
    @IBOutlet private weak var emailView: UIView!
    @IBOutlet private weak var emailTextField: UITextField!
    
    @IBOutlet private weak var passwordView: UIView!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    @IBOutlet private weak var mobileView: UIView!
    @IBOutlet weak var codeTextField: DropDown!
    @IBOutlet private weak var mobileTextField: UITextField!
    
    @IBOutlet private weak var countryView: UIView!
    @IBOutlet private weak var countryTextField: DropDown!
    
    @IBOutlet private weak var genderView: UIView!
    @IBOutlet private weak var genderMaleBttn: UIButton!
    @IBOutlet private weak var genderFemaleBttn: UIButton!
    @IBOutlet private weak var genderOtherBttn: UIButton!
    
    
    @IBOutlet private weak var hobbyTextField: DropDown!
    @IBOutlet private weak var hobbyView: UIView!
    @IBOutlet private weak var continueBttn: UIButton!
    
    //MARK: - View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setInitialLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.profileOnTapGesture()
        self.getCountryListAPI()
        self.setHobbyListData()
    }
   
    //MARK: - IB Button Actions
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //    MARK: SignUp Button Action
    @IBAction func signupButtonAction(_ sender: Any) {
        let userName = self.nameTextField.text
        let userEmail = self.emailTextField.text
        let userPassword = self.passwordTextField.text
        let mobileNumber = self.mobileTextField.text
        let hobby = self.hobbyTextField.text
        let country = self.selectedCountry
        let hobbies = self.hobbyIndex
        let gender = self.selectedGender.trimmingCharacters(in: .whitespacesAndNewlines)
        guard  let name = userName, let email = userEmail, let password = userPassword, let mobile = mobileNumber  else{
            return
        }
        let error = Validation.validateInputData(name: name, email: email, password: password, mobile: mobile, hobbies: hobbies ?? 0, gender: gender)
        
        if !error.isEmpty{
            AlertController.CreateAlertMessage(title: Constant.error, message: error, viewController: self)
        }
        else{
            self.showActivityIndicator(titleMessage: Constant.isSignupLoading)
            self.registrationAPI(name: name, email: email, password: password, gender: gender, country: country, mobile: mobile, hobbies: hobbies ?? 0 )
        }
        
    }
    
    //    MARK: Gender button action
    @IBAction func genderButtonAction(_ sender: UIButton) {
        self.genderMaleBttn.isSelected = false
        self.genderFemaleBttn.isSelected = false
        self.genderOtherBttn.isSelected = false
        self.genderMaleBttn.setImage(UIImage(named: "unselected"), for: .normal)
        self.genderFemaleBttn.setImage(UIImage(named: "unselected"), for: .normal)
        self.genderOtherBttn.setImage(UIImage(named: "unselected"), for: .normal)
        
        if !sender.isSelected{
            sender.setImage(UIImage(named: "record"), for: .normal)
            sender.isSelected = true
            if let gender = sender.titleLabel?.text{
                self.selectedGender  = gender
                print(self.selectedGender)
            }
            return
        }else{
            sender.setImage(UIImage(named: "unselected"), for: .normal)
            sender.isSelected = false
            return
        }
    }
    
}

extension SignupVC {
    //    MARK: setup layout initailization
    func setInitialLayout(){
//          profile view border layout setup
        self.profileView.layer.cornerRadius = min(self.profileView.frame.size.height, self.profileView.frame.size.width) / 2.0
        self.profileView.layer.borderWidth = 1
        self.profileView.clipsToBounds = true
        
        self.profileView.backgroundColor = ColorCode.profileColor
        self.pickProfileImage.layer.cornerRadius = min(self.profileView.frame.size.height,  self.pickProfileImage.frame.size.width) / 2.0
        self.pickProfileImage.clipsToBounds = true
        
        self.nameView.setLayoutForSignUp()
        self.emailView.setLayoutForSignUp()
        self.passwordView.setLayoutForSignUp()
        self.mobileView.setLayoutForSignUp()
        self.countryView.setLayoutForSignUp(cornerRadius: 10.0)
        self.hobbyView.setLayoutForSignUp(cornerRadius: 10.0)
        
        self.continueBttn.layer.cornerRadius = 25
        self.continueBttn.layer.borderColor = ButtonColor.defaultColor.cgColor
    }
    
} // end extension body


//    MARK: Picker delegates
extension SignupVC: UIImagePickerControllerDelegate {
//    picker delegate and allow picking from photo library
    @objc func selectProfileImage() {
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        present(picker, animated: true, completion: nil)
    }
    
    // Profile tap gesture
    private func profileOnTapGesture(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.selectProfileImage))
        pickProfileImage.addGestureRecognizer(tapGestureRecognizer)
        pickProfileImage.isUserInteractionEnabled = true
    }
    //    select image for profile
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
           let localUrl = (info[UIImagePickerController.InfoKey.mediaURL] ?? info[UIImagePickerController.InfoKey.referenceURL]) as? NSURL  {
            pickProfileImage.image =  image
            self.pickerImageData.append(image)
        }
    }
    
    
    //    maximum length setup for mobile number
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.mobileTextField{
            var maxLength: Int = 10
            let currentStr:NSString = textField.text! as NSString
            let newStr:NSString = currentStr.replacingCharacters(in: range, with: string) as! NSString
            return newStr.length <= maxLength
        }
        return true
    }
} // extension end body



extension SignupVC{
//   MARK: Registration API
    func registrationAPI(name:String , email: String, password:String , gender:String , country:String, mobile:String , hobbies:Int){
        DispatchQueue.global().async {
            APIManager.registrationAPIRequest(name: name, email: email, gender: gender, country: country, password: password, phoneNumber: mobile, selectedProfile: (self.pickerImageData.last ?? UIImage(named: "null-data"))!, hobbies: hobbies ?? 0) { data, errorMessage  in
                self.hideActivityIndicator()
                if data == 200{
                    AlertController.alertWithCompletionHandler(title: Constant.success, message: errorMessage, viewController: self) { [self] in
                        let viewController =  self.storyboard?.instantiateViewController(withIdentifier: "NewPasswordVC") as! NewPasswordVC
                        viewController.isHideShow = ((self.isFieldShow) != false)
                        viewController.emailAddress = email
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                }else{
                    AlertController.CreateAlertMessage(title: Constant.error, message: errorMessage, viewController: self)
                }
            }
        }
    }
    
    //   MARK: Country list API
    private func getCountryListAPI(){
        DispatchQueue.global().async {
            // Api request for country
            APIManager.countryListAPI{ data in
                if let data  = data{
                    for i in 0...(data.count) - 1 {
                        self.countryTextField.optionArray.append("\((data[i].name)) ")
                        self.codeTextField.optionArray.append("\(data[i].dialCode)")
                        self.selectedCountry = data[i].name
                        
                    }
                }
            }
        }
    }
    
    //  MARK: Hobby list data
    func setHobbyListData(){
        self.hobbyTextField.optionArray = ["Singing" , "Dancing" ,"Cooking", "Running", "Painting"]
        self.hobbyTextField.didSelect{( selectedText , index , id) in
            self.hobbyTextField.text = "\(selectedText) \n index: \(index)"
            self.hobbyIndex =  index
        }
    }
}
