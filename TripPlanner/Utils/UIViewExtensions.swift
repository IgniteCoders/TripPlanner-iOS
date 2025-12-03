//
//  UIViewExtensions.swift
//  TripPlanner
//
//  Created by Mananas on 1/12/25.
//

import Foundation
import UIKit

extension UIView {
    func roundCorners(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true;
    }
    
    func roundCorners() {
        self.roundCorners(radius: self.layer.frame.width / 2)
    }
    
    func setBorder(width: CGFloat, color: CGColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color
    }
}
