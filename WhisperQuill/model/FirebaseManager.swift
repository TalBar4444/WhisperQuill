//
//  FirebaseUtility.swift
//  WhisperQuill
//
//  Created by Tal Bar on 20/08/2024.
//

import Foundation
import Firebase

class FirebaseManager {
    static let shared = FirebaseManager()
    
    private init() {}
    
    func getCurrentUserID() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    func getDatabaseReference() -> DatabaseReference {
        return Database.database().reference()
    }
}


