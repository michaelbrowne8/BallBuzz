//
//  ConversationViewModel.swift
//  nba
//
//  Created by Michael Browne on 4/28/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage
import UIKit

class ConversationViewModel: ObservableObject {
    @Published var comments: [Comment] = []
    
    func saveComment(comment: Comment) async -> String? {
        let db = Firestore.firestore()
        do {
            let docRef = try await db.collection("comments").addDocument(data: comment.dictionary)
            print("🐣 Data added successfully!")
            return docRef.documentID
        } catch {
            print("😡 ERROR: Could not create a new place in 'comments' \(error.localizedDescription)")
            return nil
            
        }
    }
    
    func deleteComment(comment: Comment) async {
        let db = Firestore.firestore()
        guard let id = comment.id else {
            print("😡 ERROR: id was nil. This should not have happened.")
            return
        }
        
        do {
            try await db.collection("comments").document(id).delete()
            print("🗑️ Document successfully removed")
            return
        } catch {
            print("😡 ERROR: removing document \(error.localizedDescription).")
            return
        }
    }
}
