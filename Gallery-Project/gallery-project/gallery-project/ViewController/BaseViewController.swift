//
//  BaseViewController.swift
//  gallery-project
//
//  Created by Ankush Sharma on 12/04/23.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    var menu: UIView = SlideMenu()
    var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    var loadingView: UIView = UIView()
    var bgView: UIView = UIView()
    let labl = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardOnTap()
    }
    
    func hideKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
        }
        
        @objc func dismissKeyboard() {
            view.endEditing(true)
        }
    
    func showActivityIndicator(titleMessage: String) {
        DispatchQueue.main.async {
            self.loadingView = UIView()
            self.bgView = UIView()
            
            self.bgView.frame = CGRect(x: 0.0, y: 0.0, width: ConstantHeight.screenWidth, height: ConstantHeight.screenHeight)
            self.bgView.center = self.view.center
            self.bgView.backgroundColor = .black
            self.bgView.alpha = 0.4
            self.bgView.clipsToBounds = true
            
            
            self.loadingView.frame = CGRect(x: 0.0, y: 0.0, width: 300.0, height: 200.0)
            self.loadingView.center = self.view.center
            self.loadingView.backgroundColor = .black
            self.loadingView.alpha = 1
            self.loadingView.clipsToBounds = true
            self.loadingView.layer.cornerRadius = 10

            self.spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
            self.spinner.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
            self.spinner.center = self.view.center

            
            self.labl.frame = CGRect(x: self.loadingView.frame.origin.x , y: self.loadingView.frame.origin.y + 20, width:  self.loadingView.frame.width, height: 70.0)
            self.labl.numberOfLines = 2
            self.labl.alpha = 0.8
            self.labl.textAlignment = NSTextAlignment.center
            self.labl.font = .boldSystemFont(ofSize: 18.0)
            self.labl.textColor = ColorCode.greenColor
            self.labl.text = titleMessage
            
            
            self.view.addSubview(self.loadingView)
            self.view.addSubview(self.spinner)
            self.view.addSubview(self.labl)
            self.view.addSubview(self.bgView)
            //self.view.bringSubviewToFront(self.loadingView)
            self.view.bringSubviewToFront(self.labl)
            self.view.bringSubviewToFront(self.spinner)
            self.spinner.startAnimating()
        }
         
    }

    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            self.bgView.removeFromSuperview()
            self.loadingView.removeFromSuperview()
            self.labl.removeFromSuperview()
            self.spinner.removeFromSuperview()
        }
    }
    
    func customView(){
//        menu.frame = CGRect(x: 0, y: 0, width: ConstantHeight.screenWidth, height: ConstantHeight.screenHeight)
//        self.view.addSubview(menu)
//        self.menu.alpha = 0.5
//        self.view.bringSubviewToFront(menu)
//        self.menu.clipsToBounds = true
    }
}

extension BaseViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.view.viewWithTag(textField.tag + 1)  {
                   nextField.becomeFirstResponder()
               } else {
                   textField.resignFirstResponder()
               }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
