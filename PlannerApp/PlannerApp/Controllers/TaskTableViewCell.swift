//
//  TaskTableViewCell.swift
//  PlannerApp
//
//  Created by aadeeb rashid on 4/22/22.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var catLabel: UILabel!
    
    var task: Task? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
