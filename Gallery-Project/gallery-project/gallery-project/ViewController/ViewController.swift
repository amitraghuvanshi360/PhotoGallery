//
//  ViewController.swift
//  gallery-project
//
//  Created by Ankush Sharma on 06/04/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var profileView: UIView!
    @IBOutlet private weak var startedButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initLayout()
    }
    @IBAction func proceedToNextAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc , animated: true)
    }
}




extension ViewController{
    func initLayout(){
        
        //MARK: Header setup
        self.headerView.clipsToBounds = true
        self.headerView.layer.cornerRadius = 130
        self.headerView.backgroundColor = ColorCode.darkblue
        self.headerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        //        MARK: Button style
        self.startedButton.layer.cornerRadius = 25
        
        //       MARK: Profile style
        self.profileView.layer.cornerRadius = min(self.profileView.frame.size.height, self.profileView.frame.size.width) / 2.0
        self.profileView.clipsToBounds = true
        
        
    }
}
