//
//  CreateTripViewController.swift
//  TripPlanner
//
//  Created by Mananas on 27/11/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class CreateTripViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!

    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    
    @IBOutlet weak var minBudgetTextField: UITextField!
    @IBOutlet weak var maxBudgetTextField: UITextField!
    
    @IBOutlet weak var addDestinationTextField: UITextField!
    @IBOutlet weak var destinationsStackView: UIStackView!
    @IBOutlet weak var allowOtherDestinationsSwitch: UISwitch!
    
    var destinations: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addDestination(_ sender: Any) {
        let destination = addDestinationTextField.text!
        
        /*let destinationView = DestinationView()
        destinationView.titleLabel.text = destination
        destinationsStackView.addArrangedSubview(destinationView)*/
        
        let nib = UINib(nibName: "DestinationViewCell", bundle: nil)
        let view = nib.instantiate(withOwner: nil, options: nil).first as! DestinationView
        view.titleLabel.text = destination
        view.onRemoveClick = {
            self.destinations.remove(at: self.destinations.firstIndex(of: destination)!)
            view.removeFromSuperview()
        }
        destinationsStackView.addArrangedSubview(view)
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: destinationsStackView.leadingAnchor, constant: 0),
            view.trailingAnchor.constraint(equalTo: destinationsStackView.trailingAnchor, constant: 0)
        ])
        
        destinations.append(destination)
        
        addDestinationTextField.text = ""
    }
    
    @IBAction func createTrip(_ sender: Any) {
        let userId = Auth.auth().currentUser!.uid
        let name = nameTextField.text!
        let fromDate = fromDatePicker.date
        let toDate = toDatePicker.date
        let minBudget = Int(minBudgetTextField.text!)!
        let maxBudget = Int(maxBudgetTextField.text!)!
        let allowOtherDestinations = allowOtherDestinationsSwitch.isOn
        
        Task {
            do {
                let db = Firestore.firestore()
                let docRef = try await db.collection("Trips").addDocument(data: [:])
                
                let trip = Trip(id: docRef.documentID, name: name, userId: userId, fromDate: fromDate.millisecondsSince1970, toDate: toDate.millisecondsSince1970, minBudget: minBudget, maxBudget: maxBudget, destinations: destinations, allowOtherDestinations: allowOtherDestinations)
                
                try docRef.setData(from: trip)
                
                // Add user to Trip
                let participant = Participant(userId: userId, tripId: trip.id)
                try db.collection("Participants").addDocument(from: participant)
                
                // Navigate to summary
                self.performSegue(withIdentifier: "Navigate To Summary", sender: trip)
            } catch {
                print("Error adding document: \(error)")
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Navigate To Summary" {
            (segue.destination as! ShareTripViewController).trip = sender as? Trip
        }
    }

}
