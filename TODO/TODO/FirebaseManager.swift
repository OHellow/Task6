//
//  FirebaseManager.swift
//  TODO
//
//  Created by Satsishur on 15.12.2020.
//

import FirebaseDatabase
import UIKit

class FirebaseManager {
    var ref: DatabaseReference = Database.database().reference(withPath: "to-do")
    
    func uploadNote(key: String, title: String, color: String, index: Int, font: Int = 16) {
        let data = ["key": key, "title": title, "color": color, "index": index, "font": font] as [String : Any]
        updateChild(childName: key, data: data)
    }
    
    private func updateChild(childName: String, data: [String : Any]) {
        let itemRef = self.ref.child(childName)
        itemRef.setValue(data) { (error, ref) in
            if let error = error {
                print("failed to update data with error", error.localizedDescription)
            }
            print("succesfully updated data")
        }
    }
    
    func downloadNotes(completion: @escaping ([NoteModel])-> Void) {
        ref.queryOrdered(byChild: "index").observe(.value) { (snapshot) in
            print(snapshot)
            var newNotes: [NoteModel] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let noteItem = NoteModel(snapshot: snapshot) {
                    newNotes.append(noteItem)
                }
            }
            completion(newNotes)
        }
    }
    
    func deleteNote(key: String) {
        ref.child(key).removeValue()
    }
}
