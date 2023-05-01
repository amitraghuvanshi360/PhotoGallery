//
//  TableViewCell.swift
//  gallery-project
//
//  Created by Ankush Sharma on 20/04/23.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var tableViewCell: TableViewCell!
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleView: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
