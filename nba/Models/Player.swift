//
//  Player.swift
//  nba
//
//  Created by Michael Browne on 4/19/23.
//

import Foundation

struct Player: Codable, Identifiable {
    var id: Int
    var first_name: String
    var last_name: String
    var position: String
    var height_feet: Int?
    var height_inches: Int?
    var weight_pounds: Int?
    var team: Team
}
