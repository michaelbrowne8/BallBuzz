//
//  PlayerDetailView.swift
//  nba
//
//  Created by Michael Browne on 4/19/23.
//

import SwiftUI

struct PlayerDetailView: View {
    @StateObject var playerDetailVM = PlayerDetailViewModel()
    @State private var loadingStats = true
    @State private var noStatsAvailable: Bool?
    @State private var playerAverages: SeasonAverages?
    @State private var selectedSeason = currentSeasonYear
    
    var player: Player
    
    // Have player which is object with name, position, team, height, ...
    // detailVM gets the stats, maybe need better name
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack(spacing: 0) {
                    NavigationLink {
                        CurrentTeamDetailView(team: player.team)
                    } label: {
                        Image(player.team.full_name)
                            .resizable()
                            .scaledToFit()
                            .frame(width: geo.size.width * 0.5)
                    }
                    VStack {
                        Text("\(player.first_name) \(player.last_name)")
                            .font(.title)
                            .bold()
                            .minimumScaleFactor(0.5)
                            .lineLimit(2)
                        HStack {
                            Text(player.position)
                            if player.height_feet != nil && player.height_inches != nil && player.weight_pounds != nil {
                                Text("\(player.height_feet!)'\(player.height_inches!), \(player.weight_pounds!) lbs")
                            }
                    
                        }
                        Text("\(player.team.full_name)")
                            .minimumScaleFactor(0.5)
                            .lineLimit(2)
                    }
                }
                
                Rectangle()
                    .fill(Color("Feature"))
                    .frame(height: 2)
                    .padding()
                
                
                HStack {
                    Spacer()
                    
                    Picker("Season", selection: $selectedSeason) {
                        ForEach((1979...currentSeasonYear).reversed(), id: \.self) { season in
                            Text(String(season))
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Spacer()
                    
                    NavigationLink {
                        StatFinderView(player: player)
                    } label: {
                        Text("Stat Finder")
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Spacer()
                }
                
                if playerDetailVM.isLoading || loadingStats {
                    ProgressView()
                        .tint(.red)
                        .scaleEffect(4)
                } else if noStatsAvailable ?? true {
                    Text("Player has no games played this season!")
                } else {
                    VStack {
                        HStack(alignment: .top) {
                            Text("Games Played:")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("\(playerAverages!.games_played)")
                                .font(.title2)
                        }
                        
                        HStack(alignment: .top) {
                            Text("Minutes Per Game:")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text(playerAverages!.min)
                                .font(.title2)
                        }
                        
                        HStack(alignment: .top) {
                            Text("Points Per Game:")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text(String(format: "%.2f", playerAverages!.pts))
                                .font(.title2)
                        }
                        
                        HStack(alignment: .top) {
                            Text("Assists Per Game:")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text(String(format: "%.2f", playerAverages!.ast))
                                .font(.title2)
                            
                        }
                        
                        HStack(alignment: .top) {
                            Text("Rebounds Per Game:")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text(String(format: "%.2f", playerAverages!.reb))
                                .font(.title2)
                        }
                        
                        HStack(alignment: .top) {
                            Text("Steals Per Game:")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text(String(format: "%.2f", playerAverages!.stl))
                                .font(.title2)
                        }
                        
                        HStack(alignment: .top) {
                            Text("Blocks Per Game:")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text(String(format: "%.2f", playerAverages!.blk))
                                .font(.title2)
                            
                        }
                        
                        HStack(alignment: .top) {
                            Text("Turnovers Per Game:")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text(String(format: "%.2f", playerAverages!.turnover))
                                .font(.title2)
                        }
                        
                        Group {
                            HStack(alignment: .top) {
                                Text("Field Goal Pct:")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Text(String(format: "%.3f", playerAverages!.fg_pct) + "%")
                                    .font(.title2)
                            }
                            
                            HStack(alignment: .top) {
                                Text("3 Pointer Pct:")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text(String(format: "%.3f", playerAverages!.fg3_pct) + "%")
                                    .font(.title2)
                                
                            }
                            
                            HStack(alignment: .top) {
                                Text("Free Throw Pct:")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text(String(format: "%.3f", playerAverages!.ft_pct) + "%")
                                    .font(.title2)
                            }
                        }
                    }
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.accentColor, lineWidth: 2)
                    }
                }
                
                NavigationLink {
                        ConversationView(player: player)
                } label: {
                    Text("Conversation")
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
                    .border(.gray)
            }
            .padding(.horizontal, 5.0)
            .navigationTitle("Player")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await updateAverages()
            }
            .onChange(of: selectedSeason) { _ in
                Task {
                    await updateAverages()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color("Feature") , for: .navigationBar)
        .toolbarBackground(.visible , for: .navigationBar)
    }
    
    func updateAverages() async {
        loadingStats = true
        playerDetailVM.urlString = "https://www.balldontlie.io/api/v1/season_averages?player_ids[]=\(player.id)&season=\(selectedSeason)"
        await playerDetailVM.getData()
        loadingStats = false
        noStatsAvailable = playerDetailVM.seasonAverages.isEmpty
        if !noStatsAvailable! {
            playerAverages = playerDetailVM.seasonAverages.first!
        }
        
    }
}

struct PlayerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PlayerDetailView(player: Player(id: 237, first_name: "LeBron", last_name: "James", position: "F", height_feet: 6, height_inches: 8, weight_pounds: 250, team: Team(id: 14, abbreviation: "LAL", city: "Los Angeles", conference: "West", division: "Pacific", full_name: "Los Angeles Lakers", name: "Lakers")))
        }
    }
}
