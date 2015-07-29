//
//  UserTableViewCell.swift
//  DateUp
//
//  Created by Janan Rajaratnam on 7/28/15.
//  Copyright (c) 2015 Janan Rajaratnam. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    //IBOutlets for the cell
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.height/2
        self.avatarImageView.layer.masksToBounds = true
        
        
    }

}
