//
//  ShareTripViewController.swift
//  TripPlanner
//
//  Created by Mananas on 27/11/25.
//

import UIKit

class ShareTripViewController: UIViewController {
    
    var trip: Trip!
    
    @IBOutlet weak var tripCodeTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tripCodeTextField.text = trip.id
    }
    
    @IBAction func copyTripCode(_ sender: Any) {
        UIPasteboard.general.string = tripCodeTextField.text
    }
    
    @IBAction func shareTripCode(_ sender: Any) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
