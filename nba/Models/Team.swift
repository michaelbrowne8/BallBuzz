//
//  Team.swift
//  nba
//
//  Created by Michael Browne on 4/21/23.
//

import Foundation

struct Team: Codable, Identifiable {
    var id: Int
    var abbreviation: String
    var city: String
    var conference: String
    var division: String
    var full_name: String
    var name: String
}
