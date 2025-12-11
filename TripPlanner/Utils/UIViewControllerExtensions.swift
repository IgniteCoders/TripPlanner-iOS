//
//  UIViewController+UIAlertController.swift
//  TripPlanner
//
//  Created by Mananas on 20/11/25.
//

import Foundation
import UIKit

extension UIViewController {
    
    /// Presents a transient alert with an optional title and a message, then auto-dismisses after the specified duration.
    ///
    /// - Parameters:
    ///   - title: An optional title for the alert.
    ///   - message: The message body to display.
    ///   - duration: The time interval after which the alert will dismiss automatically. Defaults to 3 seconds.
    ///   - haptic: If true, triggers a light haptic feedback when the alert is presented. Defaults to false.
    ///   - completion: Called on the main thread after the alert is dismissed (either by timeout or programmatically).
    @MainActor
    func showMessage(title: String? = nil,
                     message: String,
                     duration: TimeInterval = 3.0,
                     haptic: Bool = false,
                     completion: (() -> Void)? = nil) {
        // Ensure we are not already presenting something to avoid stacking alerts.
        guard presentedViewController == nil else {
            // Optionally, you could dismiss current and present new, but that can be jarring.
            // For now, bail out to avoid "already presenting" warnings.
            return
        }
        
        // Basic guard to ensure the view is in a window hierarchy for presentation.
        guard viewIfLoaded?.window != nil else {
            // If not yet on screen, you may choose to delay or skip.
            return
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Accessibility: provide an action so assistive technologies can dismiss without waiting.
        // Keep auto-dismiss behavior as well.
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Dismiss alert"), style: .default) { _ in
            completion?()
        })
        
        if haptic {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
        }
        
        present(alert, animated: true, completion: nil)
        
        // Auto-dismiss after duration; use weak self to avoid retain cycles if VC disappears.
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self, weak alert] in
            guard let self, let alert else { return }
            if alert.presentingViewController != nil {
                alert.dismiss(animated: true, completion: completion)
            } else {
                completion?()
            }
        }
    }
    
    /// Presents a transient alert with a message and no title, then auto-dismisses after the specified duration.
    ///
    /// - Parameters:
    ///   - message: The message body to display.
    ///   - duration: The time interval after which the alert will dismiss automatically. Defaults to 3 seconds.
    ///   - haptic: If true, triggers a light haptic feedback when the alert is presented. Defaults to false.
    ///   - completion: Called on the main thread after the alert is dismissed.
    @MainActor
    func showMessage(_ message: String,
                     duration: TimeInterval = 3.0,
                     haptic: Bool = false,
                     completion: (() -> Void)? = nil) {
        showMessage(title: nil, message: message, duration: duration, haptic: haptic, completion: completion)
    }
    
}
