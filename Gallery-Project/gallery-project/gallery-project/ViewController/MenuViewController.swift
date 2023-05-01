//
//  MenuViewController.swift
//  gallery-project
//
//  Created by Ankush Sharma on 20/04/23.
//

import Foundation
import UIKit

class MenuViewController: UIViewController{
   
    @IBOutlet weak var menuView: SlideMenuView!
    override func viewDidLoad() {
        super.viewDidLoad()
        menuView.backgroundColor = ColorCode.greenColor

    }
}
