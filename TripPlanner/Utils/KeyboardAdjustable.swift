//
//  KeyboardAdjustable.swift
//  TripPlanner
//
//  Created by Mananas on 2/12/25.
//

import Foundation
import UIKit

extension UIViewController {
    
    /// If your app targets iOS 9.0 and later or macOS 10.11 and later, you do not need to unregister an observer that you created with the function `addObserver(_:selector:name:object:)`. If you forget or are unable to remove an observer, the system cleans up the next time it would have posted to it.

    func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(_ notification: Notification) { }

    @objc func keyboardWillHide(_ notification: Notification) { }
}
