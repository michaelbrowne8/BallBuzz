//
//  Comment.swift
//  nba
//
//  Created by Michael Browne on 4/28/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Comment: Codable, Identifiable {
    @DocumentID var id: String?
    var playerId: Int
    var username: String
    var comment: String
    
    var dictionary: [String: Any] {
        return ["playerId": playerId, "username": username, "comment": comment]
    }
}

