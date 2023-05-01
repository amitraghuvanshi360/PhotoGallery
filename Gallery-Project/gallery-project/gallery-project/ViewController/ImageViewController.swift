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
    
    var imageId:Int = 0
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if newImage.contains("https://localhost:7184/") {
            let newImageUrl = newImage.replacingOccurrences(of: "https://localhost:7184/", with: Constant.BASE_URL)
            self.imageView.setImageData(urlStr: newImageUrl)
        } else {
            self.imageView.setImageData(urlStr: newImage)
        }
    }
    
    @IBAction func backActionButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func deleteImageAction(_ sender: Any) {
        
       let token =  UserDefaults.standard.object(forKey: "token")
        
        DispatchQueue.global().async { [self] in
            APIManager.deleteImageRequestAPI(token: token as! String, imageId: imageId, completion: { [self] statusCode , message in
                print(statusCode , message , self.imageId)
                
                DispatchQueue.main.async {
                    if statusCode == 200{
                        AlertController.alertWithCompletionHandler(title: Constant.success, message: message, viewController: self, completionOnOkButton: {
                            print("image deleted successfully")
                        })
                    }else if statusCode == 400{
                        AlertController.alertWithCompletionHandler(title: Constant.error, message: message, viewController: self, completionOnOkButton: {
                            print("print error while deleting image")
                        })
                    }

                }
            })

        }
    }
}
