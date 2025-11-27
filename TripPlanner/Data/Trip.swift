//
//  Trip.swift
//  TripPlanner
//
//  Created by Mananas on 27/11/25.
//

import Foundation

struct Trip: Codable {
    let id: String
    let name: String
    let userId: String
    let fromDate: Int64
    let toDate: Int64
    let minBudget: Int
    let maxBudget: Int
    let destinations: [String]
    let allowOtherDestinations: Bool
    var participants: [Participant]? = nil
}
