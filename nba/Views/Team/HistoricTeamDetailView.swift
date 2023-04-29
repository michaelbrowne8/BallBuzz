//
//  HistoricTeamDetailView.swift
//  nba
//
//  Created by Michael Browne on 4/23/23.
//

import SwiftUI

struct HistoricTeamDetailView: View {
    let team: Team
    
    var body: some View {
        VStack {
            Text(team.full_name)
                .font(.title2)
                .fontWeight(.bold)
            Image(team.full_name)
                .resizable()
                .scaledToFit()
        }
    }
}

struct HistoricTeamDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HistoricTeamDetailView(team: Team(id: 38, abbreviation: "BOM", city: "", conference: "    ", division: "", full_name: "St. Louis Bombers", name: "St. Louis Bombers"))
    }
}
