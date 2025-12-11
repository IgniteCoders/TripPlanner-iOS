//
//  DestinationView.swift
//  TripPlanner
//
//  Created by Mananas on 27/11/25.
//

import Foundation
import UIKit

class DestinationVotesView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var votesProgressView: UIProgressView!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
