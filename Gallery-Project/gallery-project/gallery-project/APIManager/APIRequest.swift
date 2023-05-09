//
//  APIRequest.swift
//  gallery-project
//
//  Created by Ankush Sharma on 10/04/23.
//

import Foundation
import UIKit
import Alamofire

struct APIUrls {
    static let UserLogin = "api/v1/Authorization/Login"
    static let UserRegistration = "api/v1/Authorization/RegisterUser"
    static let VerifyRegistration =  "api/v1/Authorization/VerifyRegistration"
    static let GenerateOtp = "api/v1/Authorization/GenerateOtp"
    static let ForgotPassword = "api/v1/Authorization/ForgotPassword"
    static let ShowImage = "api/v1/User/ShowImages"
    static let AddImage = "api/v1/User/AddImage"
    static let DeleteImage = "api/v1/User/DeleteImage"
    static let UserDetails = "api/v1/User/userDetails"
    static let ChangePassword = "api/v1/Authorization/ChangePassword"
}

class APIManager : NSObject {
    
    //    MARK: Login request api
    class func LoginRequestAPI(useremail: String, userpassword: String , completion:@escaping (User? , String) -> Void){
        let base_url = "\(Constant.BASE_URL)\(APIUrls.UserLogin)"
        guard let url = URL.init(string: base_url) else {
            return
        }
        var urlRequest = URLRequest.init(url: url)
        urlRequest.httpMethod = "POST"
        
        let params :[String: Any] = ["email" : useremail, "password" : userpassword ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params)
        urlRequest.httpBody = jsonData
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { data , response , error in
            if let errors = error {
                print(errors.localizedDescription)
            }
            
            guard let getdata = data else {
                print("Error in Data")
                return
            }
            
            let json = try? JSONSerialization.jsonObject(with: getdata, options: []) as? [String : Any]
            if let dataObj = try? JSONDecoder().decode(User.self, from: getdata ) {
                completion(dataObj , dataObj.message)
            }
        }).resume()
    }
    
    
    
    
    //    MARK: api for country codes and name
    class func countryListAPI(completion:@escaping (Country?) -> Void){
        let base_url = "https://gist.githubusercontent.com/anubhavshrimal/75f6183458db8c453306f93521e93d37/raw/f77e7598a8503f1f70528ae1cbf9f66755698a16/CountryCodes.json"
        
        guard let url = URL.init(string: base_url) else {
            return
        }
        
        var urlRequest = URLRequest.init(url: url)
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { data , response , error in
            if let errors = error {
                print(errors.localizedDescription)
            }
            
            guard let getdata = data else {
                print("Error in Data")
                return
            }
            if let dataObj = try? JSONDecoder().decode(Country.self, from: getdata ) {
                completion(dataObj)
            }
        }).resume()
    }
    
    class func getPostString(params:[String:Any]) -> String
    {
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }
    
    //   MARK: API request for register user
    class func registrationAPIRequest(name:String, email:String,gender:String,country:String, password:String,phoneNumber:String, selectedProfile:UIImage,hobbies: Int ,completion:@escaping (Int? , String) -> Void)
    {
        let parameters :[String: Any] = [ "name" : name,
                                          "email" : email,
                                          "gender" : gender,
                                          "country" : country,
                                          "password": password,
                                          "phoneNumber" : phoneNumber,
                                          "hobby" : hobbies
        ]
        let headers:HTTPHeaders = [
            "Content-type": "multipart/form-data",
            "Content-Disposition" : "form-data"
        ]
        
        let image = selectedProfile
        let imgData = image.jpegData(compressionQuality: 0.6)
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData!, withName: "ImageFile",fileName: "leaf.jpg" , mimeType: "image/jpeg")
            
            for (key, value) in parameters
            {
                
                if value is Int {
                    
                    if let valueSet = ((value) as! Int).description.data(using: .utf8) {
                        multipartFormData.append(valueSet, withName: key)
                    }
                    
                } else {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
                
            }
            
        }, usingThreshold:UInt64.init(),
                         to: "\(Constant.BASE_URL)\(APIUrls.UserRegistration)",
                         method: .post,
                         headers: headers,
                         encodingCompletion: { (result) in
            
            switch result {
            case .success(let upload, _, _):
                print("the status code is :")
                upload.uploadProgress(closure: { (progress) in
                    print("data uploading is in progress")
                })
                
                upload.responseJSON { response in
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        completion(JSON["statusCode"] as! Int, JSON["message"] as! String)
                    }
                }
                break
            case .failure(let encodingError):
                print("the error is  : \(encodingError.localizedDescription)")
                break
            }
        })
    }
    
    //    MARK: Account confirmation
    class func confirmRegistrationAPI(email:String , otp:String,completion:@escaping (ConfirmPassword?) -> Void){
        let base_url = "\(Constant.BASE_URL)\(APIUrls.VerifyRegistration)"
        guard let url = URL.init(string: base_url) else {
            return
        }
        var urlRequest = URLRequest.init(url: url)
        urlRequest.httpMethod = "POST"
        
        let params :[String: Any] = ["email" : email, "otp" : otp ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params)
        urlRequest.httpBody = jsonData
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { data , response , error in
            if let errors = error {
                print(errors.localizedDescription)
            }
            
            guard let getdata = data else {
                print("Error in Data")
                return
            }
            
            let json = try? JSONSerialization.jsonObject(with: getdata, options: []) as? [String : Any]
            
            if let dataObj = try? JSONDecoder().decode(ConfirmPassword.self, from: getdata ) {
                completion(dataObj)
            }
        }).resume()
    }
    
    
    class func forgetPasswordRequestAPI(useremail: String, completion:@escaping(Int , String)->()){
        let base_url = "\(Constant.BASE_URL)\(APIUrls.GenerateOtp)"
        guard let url = URL.init(string: base_url) else {
            return
        }
        var urlRequest = URLRequest.init(url: url)
        urlRequest.httpMethod = "POST"
        
        let params :[String: Any] = ["email" : useremail]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params)
        urlRequest.httpBody = jsonData
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { data , response , error in
            if let errors = error {
                print(errors.localizedDescription)
                
            }
            
            guard let getdata = data else {
                print("Error")
                return
            }
            
            let json = try? JSONSerialization.jsonObject(with: getdata, options: []) as? [String : Any]
            
            if let dataObj = try? JSONDecoder().decode(ForgetPassword.self, from: getdata ) {
                completion(dataObj.statusCode, dataObj.message)
            }
        }).resume()
    }
    
    
    class func setNewPassword(useremail: String, newpassword: String , confirmPassword: String, otp: String, completion:@escaping(Int , String)->()){
        let base_url = "\(Constant.BASE_URL)\(APIUrls.ForgotPassword)"
        guard let url = URL.init(string: base_url) else {
            return
        }
        var urlRequest = URLRequest.init(url: url)
        urlRequest.httpMethod = "POST"
        
        let params :[String: Any] = ["email" : useremail, "otp" : otp , "newPassword" : newpassword , "confirmNewPassword": confirmPassword]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params)
        urlRequest.httpBody = jsonData
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { data , response , error in
            if let errors = error {
                print(errors.localizedDescription)
            }
            
            guard let getdata = data else {
                print("Error")
                return
            }
            
            let json = try? JSONSerialization.jsonObject(with: getdata, options: []) as? [String : Any]
            
            if let dataObj = try? JSONDecoder().decode(SetNewPassword.self, from: getdata ) {
                completion(dataObj.statusCode, dataObj.message)
                
            }
        }).resume()
    }
    
    
    
    class func getImageRequestAPI(token: String , completion:@escaping(ImageModel)->()){
        let base_url = "\(Constant.BASE_URL)\(APIUrls.ShowImage)"
        guard let url = URL.init(string: base_url) else {
            return
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if  let errors = error{
                print(errors.localizedDescription)
            }
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
            
            if let dataObj = try? JSONDecoder().decode(ImageModel.self, from: data ) {
                completion(dataObj)
            }
        }.resume()
    }
    
    
    //   MARK: API request for register user
    class func uploadImageRequestAPI(token:String ,selectedProfile:UIImage ,completion:@escaping (Int? , String) -> Void)
    {
        
        let headers = [
            "Content-type": "multipart/form-data",
            "Content-Disposition" : "form-data",
            "Authorization" : "Bearer \(token)"
            
        ]
        
        let image = selectedProfile
        let imgData = image.jpegData(compressionQuality: 0.6)
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData!, withName: "formFile",fileName: "leaf.jpg" , mimeType: "image/jpeg")
            
        }, usingThreshold:UInt64.init(),
                         to: "\(Constant.BASE_URL)\(APIUrls.AddImage)",
                         method: .post,
                         headers: headers,
                         encodingCompletion: { (result) in
            
            switch result {
            case .success(let upload, _, _):
                print("the status code is :")
                upload.uploadProgress(closure: { (progress) in
                    print("data uploading is in progress")
                })
                
                upload.responseJSON { response in
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        print(JSON["message"] as! String)
                        completion(JSON["statusCode"]
                                   as! Int , JSON["message"] as! String)
                    }
                }
                break
            case .failure(let encodingError):
                print("the error is  : \(encodingError.localizedDescription)")
                break
            }
        })
    }
    
    class func deleteImageRequestAPI(token: String ,imageId: Int , completion: @escaping (Int , String) -> ()){
        let base_url = "\(Constant.BASE_URL)\(APIUrls.DeleteImage)"
        guard let url = URL.init(string: base_url) else {
            return
        }
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "POST"
        
        let params :[String: Any] = ["id" : imageId]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params)
        urlRequest.httpBody = jsonData
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if  let errors = error{
                print(errors.localizedDescription)
            }
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
            
            if let dataObj = try? JSONDecoder().decode(DeleteImage.self, from: data ) {
                completion(dataObj.statusCode, dataObj.message)
            }
        }.resume()
    }
    
    
    class func getUserDetailsRequestAPI(token: String , completion:@escaping(GetUserDetail?)->()){
        let base_url = "\(Constant.BASE_URL)\(APIUrls.UserDetails)"
        guard let url = URL.init(string: base_url) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if  let errors = error{
                print(errors.localizedDescription)
            }
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(GetUserDetail.self, from: data)
                completion(response)
            } catch {
                print("Error decoding JSON data: \(error)")
            }
        }.resume()
    }
    
    class func changePasswordRequestAPI(email: String ,currentPassword: String,newPassword:String,confirmPassword: String , completion: @escaping (PasswordModel) -> ()){
        let base_url = "\(Constant.BASE_URL)\(APIUrls.ChangePassword)"
        guard let url = URL.init(string: base_url) else {
            return
        }
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "POST"
        
        let params :[String: Any] = ["email" : email , "currentPassword": currentPassword , "newPassword" : newPassword , "confirmNewPassword": confirmPassword]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params)
        urlRequest.httpBody = jsonData
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if  let errors = error{
                print(errors.localizedDescription)
            }
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
            
            if let dataObj = try? JSONDecoder().decode(PasswordModel.self, from: data ) {
                print(dataObj)
                completion(dataObj)
            }
        }.resume()
    }
}

