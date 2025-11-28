//
//  Participant.swift
//  TripPlanner
//
//  Created by Mananas on 27/11/25.
//

import Foundation

struct Participant: Codable {
    var id: String? = nil
    let userId: String
    let tripId: String
    var fromDate: Int64? = nil
    var toDate: Int64? = nil
    var budget: Int? = nil
    var destination: String? = nil
}
