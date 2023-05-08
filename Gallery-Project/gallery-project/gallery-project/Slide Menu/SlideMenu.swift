//
//  SlideMenu.swift
//  gallery-project
//
//  Created by Ankush Sharma on 01/05/23.
//

import UIKit

protocol PassDataDelegate {
    func sendData(indexPath: String)
}

class SlideMenu: UIView{
    func sendDataToSlideMenu(data: String) -> String {
        print(data)
        return data
    }
    var delegate: PassDataDelegate?
//    MARK: Outlets and variable declaration
    var menuItemsData = ["Account Details" , "Settings" , "Privacy", "Feedback" , "Rate" ,"Call Us" , "SignOut"]
    var menuItemIcon = [UIImage(named: "dashboard"), UIImage(named: "settings") , UIImage(named: "settings"),UIImage(named: "settings"), UIImage(named: "rate-us"),UIImage(named: "rate-us") , UIImage(named: "sign-out")]
    @IBOutlet var rootView: UIView!
    @IBOutlet private weak var profileView: UIView!
    @IBOutlet private weak var profileIcon: UIImageView!
    @IBOutlet private weak var emailLbl: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        commonInit()
    }
    
//   MARK: Initialization view and layout setup
    private func commonInit(){
        Bundle.main.loadNibNamed("SlideMenu", owner: self)
        Bundle.main.loadNibNamed("TableViewCell", owner: self)
        // setting profile view layout
        self.profileView.layer.cornerRadius = min(self.profileView.frame.size.height,  self.profileView.frame.size.width) / 2.0
        self.profileIcon.layer.cornerRadius = min(self.profileIcon.frame.size.height,  self.profileIcon.frame.size.width) / 2.0
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.isScrollEnabled = true
        self.isUserInteractionEnabled = true
        self.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        self.rootView.frame = self.bounds
        self.tableView.frame = self.bounds
        addSubview(self.rootView)
    
        self.rootView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
    }
}

//MARK: Table view delegate methods
extension SlideMenu: UITableViewDataSource, UITableViewDelegate,CellPassDataDelegate {
    func sendData(indexPath: String) {
        self.delegate?.sendData(indexPath: indexPath)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItemsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
//        cell.completion = { [weak self] str in
//            self?.delegate?.sendData(indexPath: str)
//        }
        cell.delegate = self
        cell.setData(title: menuItemsData[indexPath.row] , icon: menuItemIcon[indexPath.row]!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.sendData(indexPath: self.menuItemsData[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
}

protocol CellPassDataDelegate {
    func sendData(indexPath: String)
}

//MARK: Custom TableView cell class
typealias ClousureBtnActionHandler = ((_ sender: String) -> Void)?

class TableViewCell: UITableViewCell {
    var completion : ClousureBtnActionHandler?
    var delegate: CellPassDataDelegate?
    @IBOutlet private weak var cellView: UIView!
    @IBOutlet private weak var dashboardTitle: UIButton!
    @IBOutlet private weak var imageIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(title: String , icon: UIImage){
        self.imageIcon.image = icon
        self.dashboardTitle.setTitle(title, for: .normal)
    }


    @IBAction func dashboardMenuSelectionAction(_ sender: UIButton) {
        
        if let text = sender.titleLabel?.text {
            //completion!(text)
            delegate?.sendData(indexPath: text)
        }
        
    }
}
