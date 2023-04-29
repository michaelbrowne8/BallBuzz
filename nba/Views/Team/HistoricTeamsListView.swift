//
//  HistoricTeamsListView.swift
//  nba
//
//  Created by Michael Browne on 4/24/23.
//

import SwiftUI

struct HistoricTeamsListView: View {
    let historicTeams: [Team]
    @State private var teamsLeftOver = 0
    let horizontalPadding: CGFloat = 16
    let spacing: CGFloat = 0
    let teamWidth: CGFloat = 150
    
    struct DeviceWidthPreferenceKey: PreferenceKey {
        static var defaultValue: CGFloat = 0
        static func reduce (value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
        typealias Value = CGFloat
    }
    
    var body: some View {
        ScrollView {
            VStack {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: teamWidth), spacing: spacing)]) {
                    ForEach(historicTeams.dropLast(teamsLeftOver)) { team in
                        HistoricTeamDetailView(team: team)
                            .frame(width: teamWidth)
                    }
                }
                HStack {
                    ForEach(historicTeams.suffix(teamsLeftOver)) {
                        team in
                        HistoricTeamDetailView(team: team)
                            .frame(width: teamWidth)
                    }
                }
            }
            .navigationTitle("Historic Teams")
            .overlay {
                GeometryReader { geo in
                    Color.clear
                        .preference(key: DeviceWidthPreferenceKey
                            .self, value:
                                        geo.size.width)
                }
            }
            .onPreferenceChange(DeviceWidthPreferenceKey.self) {
                deviceWidth in
                arrangeGridItems(deviceWidth: deviceWidth)
            }
        }
    }
    
    func arrangeGridItems(deviceWidth: CGFloat) {
        var screenWidth = deviceWidth - horizontalPadding * 2
        if historicTeams.count > 1 {
            screenWidth += spacing
        }
        
        let numberOfButtonsPerRow = Int(screenWidth) / Int(teamWidth + spacing)
        teamsLeftOver = historicTeams.count % numberOfButtonsPerRow
    }
}


struct HistoricTeamsListView_Previews: PreviewProvider {
    static var previews: some View {
        HistoricTeamsListView(historicTeams: [Team(id: 38, abbreviation: "BOM", city: "", conference: "    ", division: "", full_name: "St. Louis Bombers", name: "St. Louis Bombers"), Team(id: 39, abbreviation: "BOM", city: "", conference: "    ", division: "", full_name: "St. Louis Bombers", name: "St. Louis Bombers")])
    }
}

