//
//  StatFinderView.swift
//  nba
//
//  Created by Michael Browne on 4/25/23.
//

import SwiftUI

struct StatFinderView: View {
    let player: Player
    @StateObject var statFinderVM = StatFinderViewModel()
    
    @State private var selectedView = String(currentSeasonYear) + " Season"
    @State private var isSheetPresented = false
    
    @State private var minutesBound = 0.0
    @State private var minutesBoundIsMin = true
    @State private var pointsBound = 0.0
    @State private var pointsBoundIsMin = true
    @State private var assistsBound = 0.0
    @State private var assistsBoundIsMin = true
    @State private var reboundsBound = 0.0
    @State private var reboundsBoundIsMin = true
    @State private var blocksBound = 0.0
    @State private var blocksBoundIsMin = true
    @State private var stealsBound = 0.0
    @State private var stealsBoundIsMin = true
    @State private var threesBound = 0.0
    @State private var threesBoundIsMin = true
    @State private var turnoversBound = 0.0
    @State private var turnoversBoundIsMin = true
    
    @State private var filterOn = false
    @State private var statsToShow: [GameStats] = []
    
    let views = [String(currentSeasonYear) + " Season", "Last 10", "Playoffs"]
    
    var body: some View {
        VStack {
            Text("\(player.first_name) \(player.last_name)")
                .font(.title2)
                .padding()
            
            Picker("Team Select", selection: $selectedView) {
                ForEach(views, id: \.self) { view in
                    Text(view)
                }
            }
            .pickerStyle(.segmented)
            
            HStack {
                
                Toggle(isOn: $filterOn) {
                    Text("")
                }
                
                Spacer()
                
                Button("Filter Stats") {
                    isSheetPresented.toggle()
                    filterOn = false
                }
                .buttonStyle(.borderedProminent)
                
                
                Spacer()
            }
            if statFinderVM.isLoading {
                ProgressView()
                    .tint(.red)
                    .scaleEffect(4)
            } else if getStatsToDisplay().isEmpty {
                Text("No stats available for this selection!")
            } else {
                let statsToShow = getStatsToDisplay()
                Text("\(statsToShow.count) Games Played")
                GeometryReader { geo in
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Date")
                                .frame(width: geo.size.width * 0.3)
                            Spacer()
                            Text("PTS")
                                .frame(width: geo.size.width * 0.2)
                            Spacer()
                            Text("AST")
                                .frame(width: geo.size.width * 0.2)
                            Spacer()
                            Text("REB")
                                .frame(width: geo.size.width * 0.2)
                        }
                        ScrollView {
                            ForEach(statsToShow) { stats in
                                NavigationLink {
                                    GameStatsView(stats: stats)
                                } label: {
                                    HStack {
                                        Text(stats.game.date.prefix(10))
                                            .frame(width: geo.size.width * 0.3)
                                            .foregroundColor(.black)
                                        Spacer()
                                        Text("\(stats.pts)")
                                            .frame(width: geo.size.width * 0.2)
                                        Spacer()
                                        Text("\(stats.ast)")
                                            .frame(width: geo.size.width * 0.2)
                                        Spacer()
                                        Text("\(stats.reb)")
                                            .frame(width: geo.size.width * 0.2)
                                    }
                                    .frame(maxHeight: 50)
                                    .foregroundColor(filterOn ? getStatsColor(stats: stats) : .black)
                                }
                                .padding(2.0)
                                .border(.black)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color("Feature") , for: .navigationBar)
        .toolbarBackground(.visible , for: .navigationBar)
        .navigationTitle("Stat Finder")
        .task {
            statFinderVM.urlString = "https://www.balldontlie.io/api/v1/stats?seasons[]=\(currentSeasonYear)&player_ids[]=\(player.id)&per_page=100"
            await statFinderVM.loadAll()
        }
        .sheet(isPresented: $isSheetPresented) {
            NavigationStack {
                ScrollView {
                    VStack {
                        StatFilter(label: "MIN", statBound: $minutesBound, statBoundIsMin: $minutesBoundIsMin, sliderMin: 0, sliderMax: 70)
                        
                        StatFilter(label: "PTS", statBound: $pointsBound, statBoundIsMin: $pointsBoundIsMin, sliderMin: 0, sliderMax: 100)
                        
                        StatFilter(label: "AST", statBound: $assistsBound, statBoundIsMin: $assistsBoundIsMin, sliderMin: 0, sliderMax: 30)
                        
                        StatFilter(label: "REB", statBound: $reboundsBound, statBoundIsMin: $reboundsBoundIsMin, sliderMin: 0, sliderMax: 60)
                        
                        StatFilter(label: "BLK", statBound: $blocksBound, statBoundIsMin: $blocksBoundIsMin, sliderMin: 0, sliderMax: 20)
                        
                        StatFilter(label: "STL", statBound: $stealsBound, statBoundIsMin: $stealsBoundIsMin, sliderMin: 0, sliderMax: 15)
                        
                        StatFilter(label: "3PM", statBound: $threesBound, statBoundIsMin: $threesBoundIsMin, sliderMin: 0, sliderMax: 16)
                        
                        StatFilter(label: "TO", statBound: $turnoversBound, statBoundIsMin: $turnoversBoundIsMin, sliderMin: 0, sliderMax: 15)
                    }
                }
                .padding()
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Return") {
                            isSheetPresented.toggle()
                        }
                    }
                }
            }
        }
    }
    
    func updateStats() async {
        statFinderVM.urlString = "https://www.balldontlie.io/api/v1/stats?seasons[]=\(currentSeasonYear)&player_ids[]=\(player.id)&per_page=100"
        await statFinderVM.loadAll()
    }
    
    func getStatsColor(stats: GameStats) -> Color {
        var filtersApply = true
        
        if (minutesBoundIsMin && Int(stats.min)! < Int(minutesBound)) || (!minutesBoundIsMin && Int(stats.min)! > Int(minutesBound)) {
            filtersApply = false
        }
        
        if (pointsBoundIsMin && stats.pts < Int(pointsBound)) || (!pointsBoundIsMin && stats.pts > Int(pointsBound)) {
            filtersApply = false
        }
        
        if (assistsBoundIsMin && stats.ast < Int(assistsBound)) || (!assistsBoundIsMin && stats.ast > Int(assistsBound)) {
            filtersApply = false
        }
        
        if (reboundsBoundIsMin && stats.reb < Int(reboundsBound)) || (!reboundsBoundIsMin && stats.reb > Int(reboundsBound)) {
            filtersApply = false
        }
        
        if (blocksBoundIsMin && stats.blk < Int(blocksBound)) || (!blocksBoundIsMin && stats.blk > Int(blocksBound)) {
            filtersApply = false
        }
        
        if (stealsBoundIsMin && stats.stl < Int(stealsBound)) || (!stealsBoundIsMin && stats.stl > Int(stealsBound)) {
            filtersApply = false
        }
        
        if (threesBoundIsMin && stats.fg3m < Int(threesBound)) || (!threesBoundIsMin && stats.fg3m > Int(threesBound)) {
            filtersApply = false
        }
        
        if (turnoversBoundIsMin && stats.turnover < Int(turnoversBound)) || (!turnoversBoundIsMin && stats.turnover > Int(turnoversBound)) {
            filtersApply = false
        }
        
        let statsColor = filtersApply ? Color.green : Color.red
        return statsColor
    }
    
    func getStatsToDisplay() -> [GameStats] {
        return selectedView == "Last 10" ? statFinderVM.last10Stats : selectedView == "Playoffs" ? statFinderVM.playoffStats : statFinderVM.playerStats
    }
}

struct StatFinderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            StatFinderView(player: Player(id: 237, first_name: "LeBron", last_name: "James", position: "F", height_feet: 6, height_inches: 8, weight_pounds: 250, team: Team(id: 14, abbreviation: "LAL", city: "Los Angeles", conference: "West", division: "Pacific", full_name: "Los Angeles Lakers", name: "Lakers")))
        }
    }
}

