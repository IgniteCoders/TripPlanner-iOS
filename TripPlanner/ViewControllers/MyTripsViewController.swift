//
//  MyTripsViewController.swift
//  TripPlanner
//
//  Created by Mananas on 27/11/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class MyTripsViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var trips: [Trip] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Task {
            self.trips = await self.getTrips()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Trip Cell", for: indexPath) as! TripViewCell
        let trip = trips[indexPath.row]
        cell.render(with: trip)
        return cell
    }
    
    func getTrips() async -> [Trip] {
        let userID = Auth.auth().currentUser!.uid
        var trips: [Trip] = []
        
        do {
            let db = Firestore.firestore()
            let querySnapshot = try await db.collection("Participants").whereField("userId", isEqualTo: userID).getDocuments()
            
            for document in querySnapshot.documents {
                let participant = try document.data(as: Participant.self)
                var trip = try await db.collection("Trips").document(participant.tripId).getDocument(as: Trip.self)
                
                
                trip.participants = await getParticipants(byTripId: trip.id)
                
                trips.append(trip)
            }
        } catch {
            print("Error reading chats from Firestore: \(error)")
        }
        
        return trips
    }
    
    func getParticipants(byTripId tripId: String) async -> [Participant] {
        var participants: [Participant] = []
        
        do {
            let db = Firestore.firestore()
            let querySnapshot = try await db.collection("Participants").whereField("tripId", isEqualTo: tripId).getDocuments()
            for document in querySnapshot.documents {
                var participant = try document.data(as: Participant.self)
                participant.id = document.documentID
                participants.append(participant)
            }
        } catch {
            print("Error reading chats from Firestore: \(error)")
        }
        return participants
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let summaryViewController = segue.destination as! SummaryViewController
        let indexPath = tableView.indexPathForSelectedRow!
        let trip = trips[indexPath.row]
        summaryViewController.trip = trip
        tableView.deselectRow(at: indexPath, animated: true)
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
