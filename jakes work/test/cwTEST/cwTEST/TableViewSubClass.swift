//
//  TableViewSubClass.swift
//  cwTEST
//
//  Created by user137042 on 1/14/19.
//  Copyright © 2019 Powell J (FCES). All rights reserved.
//

import UIKit

class TableViewSubClass: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var winnerLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!

    
}
