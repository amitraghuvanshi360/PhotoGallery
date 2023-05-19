//
//  ImageViewController.swift
//  gallery-project
//
//  Created by Ankush Sharma on 20/04/23.
//

import Foundation
import UIKit


class ImageViewController : UIViewController{
    var newImage: String = ""
    
    @IBOutlet private weak var deleteImage: UIButton!
    var imageId:Int = 0
    @IBOutlet private weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setButtonLayout()
        self.displayImage()
    }
    
    @IBAction func backActionButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func deleteImageAction(_ sender: Any) {
        let token =  UserDefaults.standard.object(forKey: "token")
        self.deleteImageAPI(authToken: token as! String)
    }
}


extension ImageViewController {
    
    func setButtonLayout(){
        self.deleteImage.layer.cornerRadius = 20
        
    }
    func displayImage(){
        if newImage.contains("https://localhost:7184/") {
            let newImageUrl = newImage.replacingOccurrences(of: "https://localhost:7184/", with: Constant.BASE_URL)
            self.imageView.setImageData(urlStr: newImageUrl)
        }else if(newImage.isEmpty){
            imageView.image = UIImage(named: "null-data")
        }
        else {
            self.imageView.setImageData(urlStr: newImage)
        }
    }
}


extension ImageViewController {
    func deleteImageAPI(authToken: String){
        DispatchQueue.global().async { [self] in
            APIManager.deleteImageRequestAPI(token: authToken as! String, id: imageId, completion: { [self] statusCode , message in
                print(statusCode , message , self.imageId)
                
                DispatchQueue.main.async {
                    if statusCode == 200{
                        AlertController.alertWithCompletionHandler(title: Constant.success, message: message, viewController: self, completionOnOkButton: {
                            self.imageView.image = UIImage(named: ("null-data"))
                            print("image deleted successfully")
                        })
                    }else if statusCode == 400{
                        AlertController.alertWithCompletionHandler(title: Constant.error, message: message, viewController: self, completionOnOkButton: {
                            print("print error while deleting image")
                        })
                    }else {
                        AlertController.CreateAlertMessage(title: Constant.error, message: Constant.isInvalid, viewController: self)
                    }
                    
                }
            })
            
        }
    }
}
