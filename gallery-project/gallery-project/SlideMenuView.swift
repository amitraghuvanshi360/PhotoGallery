//
//  SlideMenuView.swift
//  gallery-project
//
//  Created by Ankush Sharma on 20/04/23.
//

import UIKit

class SlideMenuView: UIView {
    
    

    var iconData = ["dashboard" , "settings" , "leaderboard"]
    @IBOutlet private weak var outerView: UIView!
    @IBOutlet private weak var innerView: UIView!
    @IBOutlet private weak var tableVw: UITableView!
    @IBOutlet private weak var profileView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        tableVw.delegate = self
//        tableVw.dataSource = self
    }

    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commit()
    }
    
    private func commit(){
        Bundle.main.loadNibNamed("SlideMenuView", owner: self, options: nil)
        addSubview(outerView)
        outerView.frame = self.bounds
        outerView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
    }
}


//extension SlideMenuView: UITableViewDelegate, UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        self.iconData.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let identifier = "TableViewCell"
//        var cell:TableViewCell! = tableVw.dequeueReusableCell(withIdentifier: identifier) as? TableViewCell
//        if cell == nil {
//            tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
//            cell = tableVw.dequeueReusableCell(withIdentifier: identifier) as? TableViewCell
//        }
//
//        return cell
//
//    }
//
//}
