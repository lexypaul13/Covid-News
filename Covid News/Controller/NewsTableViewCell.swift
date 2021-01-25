//
//  NewsTableViewCell.swift
//  Covid News
//
//  Created by Alex Paul on 8/23/20.
//  Copyright © 2020 Alexander Paul. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
  
  @IBOutlet weak var authorName: UILabel!
  @IBOutlet weak var headLine: UILabel!
  @IBOutlet weak var timePublication: UILabel!
  @IBOutlet weak var newsImage: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
}
