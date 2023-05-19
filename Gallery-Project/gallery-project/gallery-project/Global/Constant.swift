//
//  Constant.swift
//  gallery-project
//
//  Created by Ankush Sharma on 10/04/23.
//

import Foundation
import UIKit

class New {
    class func NewAPI<T: Decodable>(useremail: String, userpassword: String , completion: @escaping ((Result<T, Error>) -> Void) )  {
    }
}

struct Constant{
    static let BASE_URL = "http://192.168.1.148:5181/"
    static let ok = "Ok"
    static let done = "Done"
    static let error = "Error"
    static let success = "Success"
    static let warnings = "Warning"
    static let failure = "Failure"
    static let enterName = "Please enter your name"
    static let isEnteredName = "You haven't entered name"
    static let isNameShort = "Entered name should contain atleast 3 characters"
    static let enterEmail = "Please enter a valid email address"
    static let enteredInvalidEmail = "Enter valid email address"
    static let enterPassword = "Please enter password"
    static let enteredInvalidPassword = "Entered password is invalid"
    static let enterMobile = "Please enter your mobile number"
    static let isMobileEntered = "Entered mobile number is invalid"
    static let isMobileLength = "Entered mobile number must be 10 digits"
    static let isHobbyEmpty = "Enter your hobbies"
    static let isHobbyShort = "Hobbies must contain atleast 3 characters"
    static let isEmailEmpty = "You haven't entered any email"
    static let isPasswordEmpty = "You haven't entered any password"
    static let isPasswordShort = "Entered password length is too short it should have atleast 6 characters"
    static let isConfirmPasswordEmpty = "Confirm password field is empty"
    static let passowrdMissmatch = "Entered password not matching try to enter same password in both field"
    static let isGenderSelected = "Please select your gender"
    static let isOtpNull = "OTP field are nil please enter valid otp"
    static let optResendMessage = "OTP resend to your email please enter valid otp"
    static let isImageUploading = "Please wait while we uploading your images..."
    static let isPendingMessage = "Please wait while we are validating your data...!!!"
    static let isSignupLoading = "Please wait while we are sending your data"
    static let isDeletePending = "Please wait while we are deleting your data"
    static let isPasswordChanged = "Your password has been changed successfully"
    static let passwordChangeRequest = "Please wait while your password is updating"
    static let isPasswordNotChanged = "Failed to change password"
    static let isInvalid = "Something went wrong"
}

struct ConstantHeight {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
}


struct Placeholder{
    static let enterName = "Update your name"
    static let enterEmail = "Update your email"
    static let enterPhone = "Update phone number"
    static let enterCountry = "Update your country"
    static let enterGender = "Update your gender"
    static let hobby = "Update your hobbies"
}
