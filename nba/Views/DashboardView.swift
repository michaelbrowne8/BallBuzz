//
//  DashboardView.swift
//  nba
//
//  Created by Michael Browne on 4/19/23.
//

import SwiftUI
import Firebase

struct DashboardView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        GeometryReader { geo in
            NavigationStack {
                ZStack {
                    Color("Background")
                        .ignoresSafeArea()
                    
                    VStack {
                        Spacer()
                        
                        NavigationLink {
                            PlayersListView()
                        } label: {
                            Text("Players")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.2)
                        }
                        
                        Spacer()
                        
                        NavigationLink {
                            TeamsListView()
                        } label: {
                            Text("Teams")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.2)
                        }
                        
                        Spacer()
                        
                        
                        Button("Sign Out") {
                            do {
                                try Auth.auth().signOut()
                                print("🪵➡️ Log out successful!")
                                dismiss()
                            } catch {
                                print("😡 ERROR: Could not sign out!")
                            }
                        }
                        .font(.title3)
                        .fontWeight(.bold)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.accentColor, lineWidth: 2)
                        }
                    }
                    .buttonStyle(.bordered)
                }
                .navigationTitle("BallBuzz")
                .toolbarBackground(Color("Feature"), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
            }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
