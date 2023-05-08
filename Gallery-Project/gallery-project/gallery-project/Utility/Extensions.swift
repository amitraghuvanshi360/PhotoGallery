//
//  Extensions.swift
//  gallery-project
//
//  Created by Ankush Sharma on 13/04/23.
//

import Foundation
import UIKit

extension UIView {
    
    func setLayoutForSignUp(cornerRadius: CGFloat = 25.0) {
        self.layer.borderWidth = 1
        self.layer.borderColor = ColorCode.defaultColor.cgColor
        self.layer.cornerRadius = cornerRadius
    }
    
}

// field view border and corner setup
extension UIView{
    func fieldLayoutStyle(){
        self.layer.cornerRadius = 20
        self.layer.borderWidth  = 1
        self.layer.borderColor = ColorCode.defaultColor.cgColor
    }
}

extension UIImageView {
    func setImageData(urlStr: String) {
        let url = URL(string: urlStr)
        if url != nil {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    if let unwappedData = data {
                        let image = UIImage(data: unwappedData)
                        self.image = image
                        self.contentMode = .scaleAspectFill
                    }else{
                        self.image = UIImage(named: "null-data")
                    }
                }
            }
        }
    }
}
