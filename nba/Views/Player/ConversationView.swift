//
//  ConversationView.swift
//  nba
//
//  Created by Michael Browne on 4/28/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct ConversationView: View {
    let player: Player
    @FirestoreQuery(collectionPath: "comments") var comments: [Comment]
    @StateObject var conversationVM = ConversationViewModel()
    @State private var newCommentText = ""
    
    var body: some View {
        let commentsToShow = comments.filter{ $0.playerId == player.id }
        
        VStack {
            ZStack {
                List(commentsToShow) { comment in
                    HStack {
                        Text(comment.username)
                            .fontWeight(.bold)
                        Text(comment.comment)
                    }
                }
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.accentColor, lineWidth: 2)
                }
                
                if commentsToShow.isEmpty {
                    Text("No comments yet!")
                }
            }
            
            Spacer()
            
            TextField("Comment", text: $newCommentText)
                .padding(.horizontal, 3)
                .frame(minHeight: 30)
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.accentColor, lineWidth: 2)
                }
            
            Button("Post") {
                Task {
                    var username = Auth.auth().currentUser?.email ?? "User"
                    
                    if username.contains("@") {
                        username = username.components(separatedBy: "@")[0]
                    }
                    
                    _  = await conversationVM.saveComment(comment: Comment(playerId: player.id, username: username, comment: newCommentText))
                }
            }
            .buttonStyle(.bordered)
            .disabled(newCommentText == "")
        }
        .padding()
        .font(.callout)
        .listStyle(.plain)
        .navigationTitle("Conversation")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color("Feature") , for: .navigationBar)
        .toolbarBackground(.visible , for: .navigationBar)
    }
}

struct ConversationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ConversationView(player: Player(id: 237, first_name: "LeBron", last_name: "James", position: "F", height_feet: 6, height_inches: 8, weight_pounds: 250, team: Team(id: 14, abbreviation: "LAL", city: "Los Angeles", conference: "West", division: "Pacific", full_name: "Los Angeles Lakers", name: "Lakers")))
        }
    }
}
