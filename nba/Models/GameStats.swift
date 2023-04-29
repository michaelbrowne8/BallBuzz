//
//  GameStats.swift
//  nba
//
//  Created by Michael Browne on 4/25/23.
//

import Foundation

struct GameStats: Codable, Identifiable {
    let id: Int
    let ast: Int
    let blk: Int
    let fg3a: Int
    let fg3m: Int
    let fga: Int
    let fgm: Int
    let game: TeamIdGame
    let min: String
    let pts: Int
    let reb: Int
    let stl: Int
    let turnover: Int
}
