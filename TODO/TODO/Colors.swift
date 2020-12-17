//
//  Colors.swift
//  TODO
//
//  Created by Satsishur on 15.12.2020.
//

import UIKit

enum NoteColors {
    static let pink = UIColor(red: 241/255, green: 204/255, blue: 229/255, alpha: 1)
    static let blue = UIColor(red: 211/255, green: 233/255, blue: 251/255, alpha: 1)
    static let yellow = UIColor(red: 252/255, green: 243/255, blue: 174/255, alpha: 1)
}

func getColor(colorName: String) -> UIColor {
   switch colorName {
   case "blue":
       return NoteColors.blue
   case "pink":
       return NoteColors.pink
   case "yellow":
       return NoteColors.yellow
   default:
       return NoteColors.blue
   }
}

func getColorName(from color: UIColor) -> String {
    switch color {
    case NoteColors.blue:
        return "blue"
    case NoteColors.pink:
        return "pink"
    case NoteColors.yellow:
        return "yellow"
    default:
        return "blue"
    }
}
