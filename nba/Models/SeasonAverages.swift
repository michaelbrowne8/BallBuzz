//
//  SeasonAverages.swift
//  nba
//
//  Created by Michael Browne on 4/21/23.
//

import Foundation

struct SeasonAverages: Codable {
    let games_played: Int
    let player_id: Int
    let season: Int
    let min: String
    let fgm: Double
    let fga: Double
    let fg3m: Double
    let fg3a: Double
    let ftm: Double
    let fta: Double
    let oreb: Double
    let dreb: Double
    let reb: Double
    let ast: Double
    let stl: Double
    let blk: Double
    let turnover: Double
    let pf: Double
    let pts: Double
    let fg_pct: Double
    let fg3_pct: Double
    let ft_pct: Double
}
