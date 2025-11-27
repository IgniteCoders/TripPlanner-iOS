//
//  JoinTripViewController.swift
//  TripPlanner
//
//  Created by Mananas on 27/11/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class JoinTripViewController: UIViewController {
    
    @IBOutlet weak var tripCodeTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func joinTrip(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "Uniendote al viaje...", preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
        
        let tripId = tripCodeTextField.text!
        let userId = Auth.auth().currentUser!.uid
        
        
        Task {
            do {
                let db = Firestore.firestore()
                let docReference = db.collection("Trips").document(tripId)
                
                let document = try await docReference.getDocument()
                if document.exists {
                    // Add user to Trip
                    let participant = Participant(userId: userId, tripId: tripId)
                    try db.collection("Participants").addDocument(from: participant)
                    
                    // Success
                    DispatchQueue.main.async {
                        alert.dismiss(animated: true)
                        // TODO: navigate to trip
                    }
                } else {
                    DispatchQueue.main.async {
                        alert.dismiss(animated: true)
                        self.showMessage(message: "El código de viaje introducido no es valido.")
                    }
                }
            } catch let error {
                print("Error writing user to Firestore: \(error)")
                DispatchQueue.main.async {
                    alert.dismiss(animated: true)
                    self.showMessage(message: error.localizedDescription)
                }
                return
            }
        }
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
