//
//  SummaryViewController.swift
//  TripPlanner
//
//  Created by Mananas on 28/11/25.
//

import UIKit
import FirebaseAuth

class SummaryViewController: UIViewController, UITableViewDataSource {
    
    
    var trip: Trip!
    var participant: Participant!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var summaryView: UIView!
    @IBOutlet weak var votesView: UIView!
    @IBOutlet var cardViews: [UIView]!
    @IBOutlet weak var budgetView: UIView!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var destinationsStackView: UIStackView!
    
    @IBOutlet weak var votesTableView: UITableView!
    @IBOutlet var tableViewHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        votesView.isHidden = true
        
        votesTableView.dataSource = self
        votesTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        cardViews.forEach{ view in
            view.roundCorners(radius: 32)
            view.setBorder(width: 1, color: UIColor.separator.cgColor)
        }
        
        budgetView.roundCorners(radius: 16)

        // Do any additional setup after loading the view.
        
        nameLabel.text = trip.name
        
        participant = trip.participants?.first(where: { $0.userId == Auth.auth().currentUser!.uid })
        
        if let participants = trip.participants {
            let budgets = participants.compactMap { $0.budget }   // Extrae budgets no nulos
            let total = budgets.reduce(0, +)                      // Suma todos los budgets
            let average = budgets.isEmpty ? 0 : (total / budgets.count)

            budgetLabel.text = "\(average)€"
            
            let voteCounts = Dictionary(grouping: participants, by: { $0.destination }).mapValues { $0.count }

            let allResults = trip.destinations.map { dest in
                (destination: dest, votes: voteCounts[dest] ?? 0)
            }.sorted { $0.votes > $1.votes }
            
            for (destination, votes) in allResults {
                let nib = UINib(nibName: "DestinationVotesView", bundle: nil)
                let view = nib.instantiate(withOwner: nil, options: nil).first as! DestinationVotesView
                view.titleLabel.text = destination
                view.votesLabel.text = "\(votes)"
                view.votesProgressView.progress = Float(votes) / Float(participants.count)
                
                destinationsStackView.addArrangedSubview(view)
                
                NSLayoutConstraint.activate([
                    view.leadingAnchor.constraint(equalTo: destinationsStackView.leadingAnchor, constant: 0),
                    view.trailingAnchor.constraint(equalTo: destinationsStackView.trailingAnchor, constant: 0)
                ])
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trip.participants?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Vote Cell", for: indexPath) as! VoteViewCell
        let participant = trip.participants![indexPath.row]
        cell.configure(with: participant)
        return cell
    }
    
    @IBAction func segmentedIndexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            summaryView.isHidden = false
            votesView.isHidden = true
        case 1:
            summaryView.isHidden = true
            votesView.isHidden = false
        default:
            break
        }
        summaryView.superview?.needsUpdateConstraints()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Send Vote" {
            (segue.destination as! VoteViewController).trip = trip
        } else if segue.identifier == "Add Person" {
            (segue.destination as! ShareTripViewController).trip = trip
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
