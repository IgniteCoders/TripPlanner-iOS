//
//  DestinationView.swift
//  TripPlanner
//
//  Created by Mananas on 27/11/25.
//

import Foundation
import UIKit

class DestinationOptionView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    
    var onRemoveClick: (() -> Void)!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @IBAction func removeDestination(_ sender: Any) {
        onRemoveClick()
    }
}
