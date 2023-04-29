//
//  TeamDetailViewModel.swift
//  nba
//
//  Created by Michael Browne on 4/25/23.
//

import Foundation

@MainActor
class TeamDetailViewModel: ObservableObject {
    @Published var games: [Game] = []
    @Published var isLoading = false
    var urlString = ""
    
    var pageNumber = 1
    
    private struct Returned: Codable {
        var data: [Game]
        var meta: Meta
    }
    
    struct Meta: Codable {
        var next_page: Int?
    }

    func getData() async {
        guard pageNumber != 0 else { return }
        isLoading = true
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
            self.games = self.games + returned.data
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
    
    // 82 games in a season, but with playoffs could possibly be over 100 (max on one page)
    // Call loadAll instead because want all games in one season
    // Since only doing one season of games at a time only doing two page is fine
    func loadAll() async {
        await getData()
        if pageNumber != 0 {
            urlString = urlString + "&page=2"
            await getData()
        }
    }
}
