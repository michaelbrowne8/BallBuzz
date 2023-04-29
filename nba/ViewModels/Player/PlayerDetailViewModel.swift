//
//  PlayerDetailViewModel.swift
//  nba
//
//  Created by Michael Browne on 4/19/23.
//

import Foundation

@MainActor
class PlayerDetailViewModel: ObservableObject {
    @Published var seasonAverages: [SeasonAverages] = []
    @Published var isLoading = false
    var urlString = ""

    private struct Returned: Codable {
        var data: [SeasonAverages]
    }

    func getData() async {
        isLoading = true
        print("We are accessing the url \(urlString)")

        guard let url = URL(string: urlString) else {
            print("ERROR: Could not create a URL from \(urlString)")
            isLoading = false
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            guard let returned = try? JSONDecoder().decode(Returned.self, from: data) else {
                print("JSON ERROR: Could not decode returned JSON data")
                isLoading = false
                return
            }
            self.seasonAverages = returned.data
            isLoading = false
        } catch {
            isLoading = false
            print("ERROR: Could not user URL at \(urlString) to get data and response")
        }
    }
}
