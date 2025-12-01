//
//  VoteViewController.swift
//  TripPlanner
//
//  Created by Mananas on 28/11/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class VoteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var trip: Trip!
    var participant: Participant!
    
    var selectedDestination: String? = nil
    
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePicker: UIDatePicker!

    @IBOutlet weak var budgetSlider: UISlider!
    @IBOutlet weak var minBudgetLabel: UILabel!
    @IBOutlet weak var maxBudgetLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    
    @IBOutlet weak var destinationTableView: UITableView!
    @IBOutlet var tableViewHeightConstraint: NSLayoutConstraint!
    
    //@IBOutlet weak var destinationButton: UIButton!
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
        
        destinationTableView.dataSource = self
        destinationTableView.delegate = self
        destinationTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        /*var menuItems: [UIAction] = []
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
        }*/
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trip.destinations.count + (trip.allowOtherDestinations ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = destinationTableView.dequeueReusableCell(withIdentifier: "Destination Cell", for: indexPath) as! DestinationViewCell
        if (indexPath.row == trip.destinations.count) {
            cell.render(with: "Otro")
        } else {
            cell.render(with: trip.destinations[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == trip.destinations.count) {
            self.showOtherDestinationAlert(indexPath)
        }
    }
    
    func showOtherDestinationAlert(_ indexPath: IndexPath) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Destino", message: "Propon otro destino", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Otro destino"
        }
        alert.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: {_ in
            self.destinationTableView.deselectRow(at: indexPath, animated: true)
            self.destinationTableView.cellForRow(at: indexPath)?.textLabel?.text = "Otro"
            alert.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Añadir", style: .default, handler: {_ in
            let newDestination = self.otherDestinationTextField.text!
            self.destinationTableView.cellForRow(at: indexPath)?.textLabel?.text = newDestination
            self.selectedDestination = newDestination
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
        
        if destinationTableView.indexPathForSelectedRow == nil {
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
                
                if trip.allowOtherDestinations && destinationTableView.indexPathForSelectedRow!.row == trip.destinations.count {
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
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
         if(keyPath == "contentSize") {
             if let newvalue = change?[.newKey] {
                 DispatchQueue.main.async {
                     let newsize  = newvalue as! CGSize
                     self.tableViewHeightConstraint.constant = newsize.height
                 }
             }
         }
     }
}
