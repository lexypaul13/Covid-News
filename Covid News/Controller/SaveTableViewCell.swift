//
//  SaveTableViewCell.swift
//  Covid News
//
//  Created by Alex Paul on 12/5/20.
//  Copyright © 2020 Alexander Paul. All rights reserved.
//

import UIKit

class SaveTableViewCell: UITableViewCell {
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var headLine: UILabel!
    @IBOutlet weak var timePublication: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
