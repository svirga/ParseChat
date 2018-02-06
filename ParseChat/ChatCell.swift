//
//  ChatCell.swift
//  ParseChat
//
//  Created by Simona Virga on 2/1/18.
//  Copyright © 2018 Simona Virga. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell
{

  @IBOutlet weak var chatLabel: UILabel!
  @IBOutlet weak var userLabel: UILabel!
  
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
