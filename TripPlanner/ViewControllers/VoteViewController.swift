//
//  VoteViewController.swift
//  TripPlanner
//
//  Created by Mananas on 28/11/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class VoteViewController: UIViewController {
    
    var trip: Trip!
    var participant: Participant!
    
    var selectedDestination: String? = nil
    
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePicker: UIDatePicker!

    @IBOutlet weak var budgetSlider: UISlider!
    @IBOutlet weak var minBudgetLabel: UILabel!
    @IBOutlet weak var maxBudgetLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    
    @IBOutlet weak var destinationButton: UIButton!
    var otherDestinationTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fromDatePicker.minimumDate = Date(milliseconds: trip.fromDate)
        fromDatePicker.maximumDate = Date(milliseconds: trip.toDate)
        toDatePicker.minimumDate = Date(milliseconds: trip.fromDate)
        toDatePicker.maximumDate = Date(milliseconds: trip.toDate)
        
        minBudgetLabel.text = "\(trip.minBudget) €"
        maxBudgetLabel.text = "\(trip.maxBudget) €"
        budgetLabel.text = "\(trip.minBudget) €"
        budgetSlider.minimumValue = Float(trip.minBudget)
        budgetSlider.maximumValue = Float(trip.maxBudget)
        budgetSlider.value = Float(trip.minBudget)
        
        var menuItems: [UIAction] = []
        for destination in trip.destinations {
            let destinationAction = UIAction(title: destination, image: nil) { (action) in
                self.destinationButton.setTitle(destination, for: .normal)
                self.selectedDestination = destination
            }
            menuItems.append(destinationAction)
        }
        
        if trip.allowOtherDestinations {
            let otherAction = UIAction(title: "Otro", image: nil) { (action) in
                self.showOtherDestinationAlert()
            }
            menuItems.append(otherAction)
        }

        let menu = UIMenu(title: "Destinos", options: .singleSelection, children: menuItems)

        destinationButton.menu = menu
        destinationButton.showsMenuAsPrimaryAction = true
        
        participant = trip.participants?.first(where: { $0.userId == Auth.auth().currentUser!.uid })
        
        if participant.fromDate != nil { // Ya ha votado antes
            fromDatePicker.date = Date(milliseconds: participant.fromDate!)
            toDatePicker.date = Date(milliseconds: participant.toDate!)
            
            budgetSlider.value = Float(participant.budget!)
            budgetLabel.text = "\(participant.budget!) €"
            
            destinationButton.setTitle(participant.destination!, for: .normal)
            let index = trip.destinations.firstIndex(of: participant.destination!)!
            (destinationButton.menu?.children[index] as? UIAction)?.state = .on
        }
        
    }
    
    func showOtherDestinationAlert() {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Destino", message: "Propon otro destino", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Otro destino"
        }
        alert.addAction(UIAlertAction(title: "Añadir", style: .default, handler: {_ in
            let newDestination = self.otherDestinationTextField.text!
            self.destinationButton.setTitle(newDestination, for: .normal)
            self.selectedDestination = newDestination
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: {_ in
            (self.destinationButton.menu?.children.last as? UIAction)?.state = .off
            self.destinationButton.setTitle("Seleccionar destino", for: .normal)
            alert.dismiss(animated: true)
        }))
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)

        self.otherDestinationTextField = alert.textFields?[0]
    }
    
    @IBAction func budgetChanged(_ sender: UISlider) {
        budgetLabel.text = "\(Int(sender.value)) €"
    }
    
    @IBAction func sendVote(_ sender: Any) {
        let fromDate = fromDatePicker.date.millisecondsSince1970
        let toDate = toDatePicker.date.millisecondsSince1970
        let budget = Int(budgetSlider.value)
        let destination = selectedDestination
        
        if destinationButton.menu?.selectedElements.first == nil {
            showMessage(message: "Selecione un destino")
            return
        }
        
        participant?.fromDate = fromDate
        participant?.toDate = toDate
        participant?.budget = budget
        participant?.destination = destination
        
        Task {
            do {
                let db = Firestore.firestore()
                
                if trip.allowOtherDestinations &&
                    destinationButton.menu?.selectedElements.first?.title == (destinationButton.menu?.children.last as? UIAction)?.title {
                    trip.destinations.append(selectedDestination!)
                    try db.collection("Trips").document(trip.id).setData(from: trip)
                }
                
                
                try db.collection("Participants").document(participant!.id!).setData(from: participant)
                
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            } catch let error {
                print("Error writing user to Firestore: \(error)")
                DispatchQueue.main.async {
                    self.showMessage(message: error.localizedDescription)
                }
            }
        }
    }

}
