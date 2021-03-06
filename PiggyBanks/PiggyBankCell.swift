//
//  PiggyBankCell.swift
//  PiggyBanks
//
//  Created by Adam Wayland on 3/8/15.
//  Copyright (c) 2015 Adam Wayland. All rights reserved.
//

import UIKit

class PiggyBankCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var thumbnail: PBView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var owedLabel: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var paidLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
