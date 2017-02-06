//
//  TransferToTableViewCell.swift
//  ColourBook
//
//  Created by Mark Meritt on 2017-02-05.
//  Copyright © 2017 Apptist. All rights reserved.
//

import UIKit

class TransferToTableViewCell: UITableViewCell {
    
    @IBOutlet var imgView: UIImageView!
    
    @IBOutlet var titleLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
