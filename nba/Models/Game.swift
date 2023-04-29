//
//  Game.swift
//  nba
//
//  Created by Michael Browne on 4/25/23.
//

import Foundation

struct Game: Codable, Identifiable {
    var id: Int
    var date: String
    var home_team: Team
    var home_team_score: Int
    var period: Int
    var postseason: Bool
    var visitor_team: Team
    var visitor_team_score: Int
}

struct TeamIdGame: Codable, Identifiable {
    var id: Int
    var date: String
    var home_team_id: Int
    var home_team_score: Int
    var postseason: Bool
    var visitor_team_id: Int
    var visitor_team_score: Int
}
