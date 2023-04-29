//
//  CurrentTeamDetailView.swift
//  nba
//
//  Created by Michael Browne on 4/23/23.
//

import SwiftUI

struct CurrentTeamDetailView: View {
    @StateObject var teamDetailVM = TeamDetailViewModel()
    @State private var loadingStats = true
    @State private var selectedSeason = currentSeasonYear
    @State private var gamesPlayed: [Game] = []
    var team: Team
    
    var body: some View {
        VStack {
            VStack {
                Image(team.full_name)
                    .resizable()
                    .scaledToFit()
                
                Text(team.full_name)
            }
            .frame(height: 350)
            .padding(.horizontal, 0.0)
            
            HStack {
                Picker("Season", selection: $selectedSeason) {
                    ForEach((1979...currentSeasonYear).reversed(), id: \.self) { season in
                        Text(String(season))
                    }
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
                
                Spacer()
            }
            
            if teamDetailVM.isLoading || loadingStats {
                ProgressView()
                    .scaleEffect(4)
            } else if teamDetailVM.games.isEmpty {
                Text("No games available for this team in the selected season!")

            } else {
                Text("\(gamesPlayed.count) Games Played")
                ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(gamesPlayed) { game in
                                HStack {
                                    Image(game.home_team.full_name)
                                        .resizable()
                                        .scaledToFit()
                                    Text("\(game.home_team_score) - \(game.visitor_team_score)")
                                    Image(game.visitor_team.full_name)
                                        .resizable()
                                        .scaledToFit()
                                }
                                .foregroundColor(chooseGameScoreColor(game: game))
                                .frame(maxHeight: 50)
                            }
                        }
                    }
            }
            
            Spacer()
        }
        .padding(.horizontal, 5.0)
        .navigationTitle("Team")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color("Feature") , for: .navigationBar)
        .toolbarBackground(.visible , for: .navigationBar)
        .task {
            await updateGames()
        }
        .onChange(of: selectedSeason) { _ in
            Task {
                await updateGames()
            }
            
        }
    }
    
    func updateGames() async {
        loadingStats = true
        teamDetailVM.urlString = "https://www.balldontlie.io/api/v1/games?per_page=100&team_ids[]=\(team.id)&seasons[]=\(selectedSeason)"
        await teamDetailVM.loadAll()
        gamesPlayed = teamDetailVM.games.filter({ game in
            game.period != 0
        })
        gamesPlayed = gamesPlayed.sorted { game1, game2 in
            game1.date > game2.date
        }
        loadingStats = false
    }
    
    func chooseGameScoreColor(game: Game) -> Color {
        let homeTeamWon = game.home_team_score > game.visitor_team_score
        let isHomeTeam = game.home_team.id == team.id
        if homeTeamWon == isHomeTeam {
            return .green
        } else {
            return .red
        }
    }
}

struct CurrentTeamDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentTeamDetailView(team: Team(id: 14, abbreviation: "LAL", city: "Los Angeles", conference: "West", division: "Pacific", full_name: "Los Angeles Lakers", name: "Lakers"))
    }
}
