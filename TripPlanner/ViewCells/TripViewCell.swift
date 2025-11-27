//
//  TripViewCell.swift
//  TripPlanner
//
//  Created by Mananas on 27/11/25.
//

import UIKit

class TripViewCell: UITableViewCell {
    
    @IBOutlet weak var tripNameLabel: UILabel!
    @IBOutlet weak var participantsNumberLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func render(with trip: Trip) {
        tripNameLabel.text = trip.name
        participantsNumberLabel.text = "\(trip.participants?.count ?? 0) participants"
    }
}
