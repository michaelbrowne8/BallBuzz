//
//  TeamsViewModel.swift
//  nba
//
//  Created by Michael Browne on 4/23/23.
//

import Foundation

@MainActor
class TeamsViewModel: ObservableObject {
    @Published var teamsArray: [Team] = []
    @Published var isLoading = false
    
    private struct Returned: Codable {
        var data: [Team]
    }
    
    func getData() async {
        isLoading = true
        let urlString = "https://www.balldontlie.io/api/v1/teams?per_page=50"
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
            self.teamsArray = self.teamsArray + returned.data
            isLoading = false
        }
        catch {
            isLoading = false
            print("😡 ERROR: Could not get data from \(urlString). \(error.localizedDescription)")
        }
    }
}

