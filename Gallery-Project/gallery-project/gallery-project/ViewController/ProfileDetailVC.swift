//
//  ProfileDashboardVC.swift
//  gallery-project
//
//  Created by Ankush Sharma on 03/05/23.
//

import Foundation
import UIKit

class ProfileDetailVC: UIViewController {
    
//    MARK: IBOutlets and variable declaration
  
    var titleArr: [String] = ["Name :" , "Email :" , "Phone :" , "Country: ", "Gender: ", "Hobby: "]
    var userDataArray: [String] = []
    var userInfo: UserData?
    var isFieldVisible:Bool =  false
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileContainer: UIView!
    @IBOutlet weak var editProfileBttn: UIButton!
    @IBOutlet weak var profileIcon: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initLayout()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getUserDetails()

    }
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editProfileAction(_ sender: Any) {
        if self.isFieldVisible{
            self.isFieldVisible = false
            self.tableView.reloadData()

        }else{
            self.isFieldVisible = true
            print(self.isFieldVisible)
            self.tableView.reloadData()

        }
    }
}

extension ProfileDetailVC: UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DisplayProfileData") as! DisplayProfileData
        cell.backgroundColor = ((indexPath.row % 2 ) == 0) ? ColorCode.profileContainer  : ColorCode.lightYellow
        cell.setUserData(title: titleArr ,data: self.userDataArray, index: indexPath.row, visibility: self.isFieldVisible )
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}

extension ProfileDetailVC{
    //    fetch user details API
    func getUserDetails(){
        let token = UserDefaults.standard.object(forKey: "token")
        DispatchQueue.global().async {
            APIManager.getUserDetailsRequestAPI(token: token as! String, completion: { [self] userData in
                if let unwrappeData = userData?.data{
                    self.userInfo = unwrappeData
                    self.profileIcon.setImageData(urlStr: unwrappeData.profileImage)
                    self.userDataArray.append(unwrappeData.name)
                    self.userDataArray.append(unwrappeData.email)
                    self.userDataArray.append(unwrappeData.phoneNumber)
                    self.userDataArray.append(unwrappeData.country)
                    self.userDataArray.append(unwrappeData.gender)
                    self.userDataArray.append(String(unwrappeData.hobby))
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
    } // function end
    
    
    func initLayout(){
        self.profileContainer.layer.cornerRadius = 10
        self.profileContainer.backgroundColor = ColorCode.profileContainer
        
        
        self.profileView.layer.cornerRadius = min(self.profileView.frame.size.height, self.profileView.frame.size.width) / 2.0
        self.profileView.layer.borderWidth = 1
        self.profileView.clipsToBounds = true
        
        self.profileIcon.layer.cornerRadius = min(self.profileView.frame.size.height, self.profileIcon.frame.size.width) / 2.0
        self.profileIcon.layer.borderWidth = 1
        self.profileIcon.clipsToBounds = true
    }
} // extension body end



class DisplayProfileData: UITableViewCell{
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var dataTxtField: UITextField!
    func setUserData(title: [String] , data: [String], index: Int, visibility: Bool){
        dataTxtField.layer.cornerRadius = 10
        dataTxtField.layer.borderWidth = 1
        dataLabel.layer.borderColor = ColorCode.greenColor.cgColor
        if visibility{
            titleLabel.text = title[index]
            dataTxtField.text = data.isEmpty ? " "  : "  " + data[index]

            dataLabel.isHidden = true
            dataTxtField.isHidden = false
            dataTxtField.backgroundColor =  ColorCode.profileContainer
        }
        else{
            titleLabel.text = title[index]
            if data.isEmpty{
                dataTxtField.text = ""
                dataLabel.text = ""
            }else{
                dataLabel.text = data[index]
                dataTxtField.backgroundColor  = ColorCode.lightYellow
            }
            dataTxtField.isHidden = true
            dataLabel.isHidden = false
        }
    }
}
