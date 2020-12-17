//
//  NoteModel.swift
//  TODO
//
//  Created by Satsishur on 15.12.2020.
//

import UIKit
import Firebase

struct NoteModel {
    var title: String
    var color: UIColor
    var key: String
    var indexPath: Int
    
    init(key: String, title: String, color: String, index: Int) {
        self.title = title
        self.key = key
        self.indexPath = index
        self.color = getColor(colorName: color)
    }
    
    init?(snapshot: DataSnapshot) {
      guard
        let value = snapshot.value as? [String: AnyObject],
        let title = value["title"] as? String,
        let color = value["color"] as? String,
        let key = value["key"] as? String,
        let index = value["index"] as? Int else {
        return nil
      }
        
        self.title = title
        self.key = key
        self.indexPath = index
        self.color = getColor(colorName: color)
    }
}
