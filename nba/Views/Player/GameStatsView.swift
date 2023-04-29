//
//  GameStatsView.swift
//  nba
//
//  Created by Michael Browne on 4/27/23.
//

import SwiftUI

struct GameStatsView: View {
    let stats: GameStats
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Text("Minutes:")
                    .fontWeight(.bold)
                
                Text(stats.min)
            }
            
            HStack(alignment: .top) {
                Text("Points:")
                    .fontWeight(.bold)
                
                Text("\(stats.pts)")
            }
            
            HStack(alignment: .top) {
                Text("Assists:")
                    .fontWeight(.bold)
                
                Text("\(stats.ast)")
            }
            
            HStack(alignment: .top) {
                Text("Rebounds:")
                    .fontWeight(.bold)
                
                Text("\(stats.reb)")
            }
            
            HStack(alignment: .top) {
                Text("Blocks:")
                    .fontWeight(.bold)
                
                Text("\(stats.blk)")
            }
            
            HStack(alignment: .top) {
                Text("Steals:")
                    .fontWeight(.bold)
                
                Text("\(stats.stl)")
            }
            
            HStack(alignment: .top) {
                Text("FGM/FGA:")
                    .fontWeight(.bold)

                Text("\(stats.fgm)/\(stats.fga)")
            }
            
            HStack(alignment: .top) {
                Text("FG3M/FG3A:")
                    .fontWeight(.bold)
                
                Text("\(stats.fg3m)/\(stats.fg3a)")
            }
            
            HStack(alignment: .top) {
                Text("Turnovers:")
                    .fontWeight(.bold)
                
                Text("\(stats.turnover)")
            }
        }
        .font(.title2)
    }
}

struct GameStatsView_Previews: PreviewProvider {
    static var previews: some View {
        GameStatsView(stats: GameStats(id: 1, ast: 3, blk: 2, fg3a: 5, fg3m: 2, fga: 17, fgm: 12,
                                       game: TeamIdGame(id: 1, date: "", home_team_id: 1, home_team_score: 1, postseason: false, visitor_team_id: 1, visitor_team_score: 1)
                                       ,min: "39", pts: 50, reb: 4, stl: 1, turnover: 4))
    }
}
