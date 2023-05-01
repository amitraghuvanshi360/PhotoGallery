//
//  AlertController.swift
//  gallery-project
//
//  Created by Ankush Sharma on 11/04/23.
//

import Foundation
import UIKit

struct AlertController{
    
    static func CreateAlertMessage(title: String , message: String , viewController: UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        viewController.present(alert, animated: true)
    }
    
    
    static func alertWithCompletionHandler(title: String , message: String , viewController: UIViewController, completionOnOkButton: @escaping () -> () ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { action in
            completionOnOkButton()
        }
        
        alert.addAction(action)
        viewController.present(alert, animated: true)
    }
}
