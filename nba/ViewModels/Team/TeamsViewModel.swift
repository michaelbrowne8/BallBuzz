//
//  PlayersViewModel.swift
//  nba
//
//  Created by Michael Browne on 4/19/23.
//

import Foundation

@MainActor
class TeamsViewModel: ObservableObject {
    @Published var teamsArray: [Team] = []
    @Published var isLoading = false
    @Published var loadAllLoading = false
    @Published var totalPages: Int?
    @Published var pageNumber = 1
    let pageSize = 100
    
    private struct Returned: Codable {
        var data: [Player]
        var meta: Meta
    }
    
    struct Meta: Codable {
        var total_pages: Int
        var next_page: Int?
    }
    
    func getData() async {
        guard pageNumber != 0 else { return }
        isLoading = true
        let urlString = "https://www.balldontlie.io/api/v1/players?page=\(pageNumber)&per_page=\(pageSize)"
        print("🕸️ We are accessing the url \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: Could not create a URL from \(urlString)")
            isLoading = false
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let returned = try? JSONDecoder().decode(Returned.self, from: data) else {
                print("😡JSON ERROR: Could not decode returned JSON data.")
                isLoading = false
                return
            }
            self.playersArray = self.playersArray + returned.data
            self.totalPages = returned.meta.total_pages
            if returned.meta.next_page == nil {
                pageNumber = 0
            } else {
                pageNumber = pageNumber + 1
            }
            isLoading = false
        }
        catch {
            isLoading = false
            print("😡 ERROR: Could not get data from \(urlString). \(error.localizedDescription)")
        }
    }
    
    func loadNextIfNeeded(player: Player) async {
        guard let lastPlayer = playersArray.last else {return}
        if player.id == lastPlayer.id && pageNumber != 0 {
            await getData()
        }
    }
    
    func loadAll() async {
        loadAllLoading = true

        guard pageNumber != 0 else {
            loadAllLoading = false
            return
        }
        print("Load all page number: \(pageNumber)")

        await getData()
        await loadAll()
    }
}
