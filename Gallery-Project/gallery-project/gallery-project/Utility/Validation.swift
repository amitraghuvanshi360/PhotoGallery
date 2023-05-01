//
//  Validation.swift
//  gallery-project
//
//  Created by Ankush Sharma on 11/04/23.
//

import Foundation


class Validation{
    //    MARK: Checking for valid email address
    class func isValidEmailAddress(email: String) -> Bool {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = email as NSString
            let results = regex.matches(in: email, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    //    MARK: field validations for login
    class func validateInputData(useremail: String , userpassword: String) ->String {
        var errorMessage: String = ""
        if useremail.isEmpty {
            errorMessage = Constant.isEmailEmpty
            return errorMessage
        }else if !Validation.isValidEmailAddress(email: useremail){
            errorMessage = Constant.enteredInvalidEmail
            return errorMessage
        }else if userpassword.isEmpty {
            errorMessage = Constant.enterPassword
            return errorMessage
        }else if userpassword.count < 6 {
            errorMessage = Constant.isPasswordShort
            return errorMessage
        }
        return ""
    } // function end
    
    
    
    //   MARK: Validation for signup screen
    class func validateInputData(name: String, email: String , password: String , mobile: String, hobbies: Int , gender: String) -> String{
        var errorMessage: String = ""
        if name.isEmpty {
            errorMessage = Constant.enterName
            return errorMessage
        }else if name.count < 3{
            errorMessage = Constant.isNameShort
            return errorMessage
        }
        
        else if email.isEmpty{
            errorMessage = Constant.isEmailEmpty
            return errorMessage
        }
        else if !Validation.isValidEmailAddress(email: email){
            errorMessage = Constant.enteredInvalidEmail
            return errorMessage
        }
        
        else if password.isEmpty {
            errorMessage = Constant.enterPassword
            return errorMessage
        }else if password.count < 6 {
            errorMessage = Constant.isPasswordShort
        }
        
        else if mobile.isEmpty {
            errorMessage = Constant.enterMobile
            return errorMessage
        }else if mobile.count < 10 {
            errorMessage = Constant.isMobileLength
            return errorMessage
        }else if mobile.count > 10 {
            errorMessage = Constant.isMobileEntered
            return errorMessage
        }
        
        else if hobbies == nil  || (hobbies.words.count == 0){
            errorMessage = Constant.isHobbyEmpty
            return errorMessage
        }
        
        else if gender.isEmpty{
            errorMessage = Constant.isGenderSelected
            return errorMessage
        }
        return errorMessage
    } //end validation func validation  body
    
    //    MARK: Validations for new password creation
    class func isNewPasswordValid(newPassword: String , confirmpPassword:String) ->String {
        var errorMessage:String = ""
        if newPassword.isEmpty{
            errorMessage = Constant.enterPassword
            return errorMessage
        }else if newPassword.count < 6{
            errorMessage = Constant.isPasswordShort
            return errorMessage
        }
        
        else if confirmpPassword.isEmpty{
            errorMessage = Constant.isConfirmPasswordEmpty
            return errorMessage
        }else if newPassword != confirmpPassword{
            errorMessage = Constant.passowrdMissmatch
            return errorMessage
        }
        return errorMessage
    }
    
//  MARK: Checking field validation for otp and password
    class  func isOtpValid(index1:String, index2:String , index3:String , index4:String , index5:String , index6:String) ->String {
        var errorMessage:String = ""
        if (index1.count == 0){
            errorMessage = Constant.isOtpNull
            return errorMessage
        }else if (index2.count == 0){
            errorMessage = Constant.isOtpNull
            return errorMessage
        }else if (index3.count == 0){
            errorMessage = Constant.isOtpNull
            return errorMessage
        }
        else if (index4.count == 0){
            errorMessage = Constant.isOtpNull
            return errorMessage
        }
        else if (index5.count == 0){
            errorMessage = Constant.isOtpNull
            return errorMessage
        }
        else if (index6.count == 0){
            errorMessage = Constant.isOtpNull
            return errorMessage
        }
        return errorMessage
    }
}
