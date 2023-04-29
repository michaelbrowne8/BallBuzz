//
//  TeamsListView.swift
//  nba
//
//  Created by Michael Browne on 4/23/23.
//

import SwiftUI

struct TeamsListView: View {
    @StateObject var teamsVM = TeamsViewModel()
    @State private var currentTeams: [Team] = []
    @State private var historicTeams: [Team] = []
    @State private var searchText = ""
    @State private var selectedView = "Current"
    private var views = ["Current", "Historic"]
    
    var body: some View {
        ZStack {
            
            VStack {
                Picker("Team Select", selection: $selectedView) {
                    ForEach(views, id: \.self) { view in
                        Text(view)
                    }
                }
                .pickerStyle(.segmented)
                
                switch selectedView {
                case "Current":
                    List(currentTeams) { team in
                        NavigationLink {
                            CurrentTeamDetailView(team: team)
                        } label: {
                            CurrentTeamLabel(team: team)
                        }
                    }
                    .navigationTitle("Current Teams")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarBackground(Color("Feature") , for: .navigationBar)
                    .toolbarBackground(.visible , for: .navigationBar)
                case "Historic":
                    HistoricTeamsListView(historicTeams: historicTeams)
                default:
                    List(currentTeams) { team in
                        NavigationLink {
                            CurrentTeamDetailView(team: team)
                        } label: {
                            CurrentTeamLabel(team: team)
                        }
                    }
                    .navigationTitle("Current Teams")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarBackground(Color("Feature") , for: .navigationBar)
                    .toolbarBackground(.visible , for: .navigationBar)
                }
            }
            
            if teamsVM.isLoading {
                ProgressView()
                    .tint(.red)
                    .scaleEffect(4)
            }
        }
        .listStyle(.plain)
        .navigationTitle("Teams")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color("Feature") , for: .navigationBar)
        .toolbarBackground(.visible , for: .navigationBar)
        .task {
            await teamsVM.getData()
            currentTeams = teamsVM.teamsArray.filter{team in team.id <= 30}
            historicTeams = teamsVM.teamsArray.filter{team in 30 < team.id && team.id < 50}
        }
    }
}

struct TeamsListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TeamsListView()
        }
    }
}

struct CurrentTeamLabel: View {
    let team: Team
    
    var body: some View {
        HStack {
            Image(team.full_name)
                .resizable()
                .scaledToFit()
            Text(team.full_name)
                .font(.title3)
        }
        .frame(maxHeight: 50)
    }
}
