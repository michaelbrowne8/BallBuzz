//
//  PlayersListView.swift
//  nba
//
//  Created by Michael Browne on 4/19/23.
//

import SwiftUI

struct PlayersListView: View {
    @StateObject var playersVM = PlayersViewModel()
    @State private var searchText = ""
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            VStack {
                ZStack {
                    List(searchResults) { player in
                        LazyVStack {
                            NavigationLink {
                                PlayerDetailView(player: player)
                            } label: {
                                Text("\(player.first_name) \(player.last_name)")
                                    .font(.callout)
                            }
                        }
                        .listRowBackground(Color("Background"))
                        .task {
                            await playersVM.loadNextIfNeeded(player: player)
                        }
                    }
                    .listStyle(.plain)
                    .toolbar {
                        ToolbarItem (placement: .bottomBar) {
                            Button("Load All") {
                                Task {
                                    await playersVM.loadAll()
                                }
                            }
                        }
                        ToolbarItem(placement: .status) {
                            Text("\(playersVM.playersArray.count) Players Loaded")
                            
                        }
                    }
                    .searchable(text: $searchText)
                    .disableAutocorrection(true)
                    
                    if playersVM.isLoading {
                        ProgressView()
                            .scaleEffect(4)
                    }
                }
                if playersVM.loadAllLoading {
                    ProgressView(value: CGFloat(playersVM.pageNumber) / CGFloat(playersVM.totalPages!))
                }
            }
            
        }
        .scrollContentBackground(.hidden)
        .navigationTitle("Players")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color("Feature") , for: .navigationBar)
        .toolbarBackground(.visible , for: .navigationBar)
        .task {
            await playersVM.getData()
        }
    }
    
    var searchResults: [Player] {
        if searchText.isEmpty {
            return playersVM.playersArray
        } else {
            return playersVM.playersArray.filter
            {"\($0.first_name) \($0.last_name)".lowercased().contains(searchText.lowercased())}
        }
    }
}

struct PlayersListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PlayersListView()
        }
    }
}
