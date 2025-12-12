//
//  VoteViewCell.swift
//  TripPlanner
//
//  Created by Mananas on 12/12/25.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class VoteViewCell: UITableViewCell {
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var datesLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(with vote: Participant) {
        if Auth.auth().currentUser?.uid == vote.userId {
            self.userLabel.text = "Yo"
        } else {
            Task {
                let user = await getUser(byId: vote.userId)
                DispatchQueue.main.async {
                    self.userLabel.text = user?.firstName ?? "Unknown User"
                }
            }
        }
        
        timestampLabel.text = Date.now.adding(
            days: [0, -1, -3, -5].randomElement()!,
            hours: [-2, -4, -8].randomElement()!,
            minutes: [-5, -10, -20].randomElement()!
        ).relativeDescription()//"\(vote.timestamp)"
        
        let fromDate = Date(milliseconds: vote.fromDate ?? 0)
        let toDate = Date(milliseconds: vote.toDate ?? 0)
        datesLabel.text = "\(fromDate.toString(format: "d MMM")) - \(toDate.toString(format: "d MMM"))"
        budgetLabel.text = "\(vote.budget ?? 0)€"
        destinationLabel.text = vote.destination
    }
    
    func getUser(byId userId: String) async -> User? {
        do {
            let db = Firestore.firestore()
            let docRef = db.collection("Users").document(userId)
            let document = try await docRef.getDocument()
            let user = try document.data(as: User.self)
            return user
        } catch {
            print("Error reading user from Firestore: \(error)")
        }
        return nil
    }
}
