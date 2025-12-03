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

/*protocol KeyboardAdjustable: AnyObject {
    var keyboardAdjustableConstraint: NSLayoutConstraint! { get }
    
    func handleKeyboardWillShow(_ notification: Notification)
    func handleKeyboardWillHide(_ notification: Notification)
}

extension KeyboardAdjustable where Self: UIViewController {

    internal func handleKeyboardWillShow(_ notification: Notification) {
        animateKeyboardTransition(notification, showing: true)
    }

    internal func handleKeyboardWillHide(_ notification: Notification) {
        animateKeyboardTransition(notification, showing: false)
    }
    
    private func animateKeyboardTransition(_ notification: Notification, showing: Bool) {
        guard let userInfo = notification.userInfo else { return }

            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
            let curveRaw = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt ?? 0

            // Convertimos la curva a AnimationOptions
            let options = UIView.AnimationOptions(rawValue: curveRaw << 16)

            // Altura del teclado solo si se está mostrando
            let height = showing ? keyboardFrame.height : 0
            self.keyboardAdjustableConstraint.constant = height

            // Animación con los mismos parámetros que el teclado
                UIView.animate(withDuration: duration) {
                    self.view.layoutIfNeeded()
                }
    }
}*/
