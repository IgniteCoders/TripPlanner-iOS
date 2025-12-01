//
//  TripViewCell.swift
//  TripPlanner
//
//  Created by Mananas on 27/11/25.
//

import UIKit

class DestinationViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.accessoryType = selected ? .checkmark : .none
    }

    func render(with destination: String) {
        self.textLabel?.text = destination
    }
}
