//
//  Config.swift
//  MentionsFramework
//
//  Created by Fahed Al-Ahmad on 4/17/19.
//  Copyright © 2019 Fahed Al-Ahmad. All rights reserved.
//

import Foundation

enum FontWeight: String{
    case heavy = "Heavy"
    case medium = "Medium"
    case light = "Light"
}


class Config {
    
    private static let fontName = "Avenir-"
    
    static func mentionStringAttrubures(weight: FontWeight, size: Int)->[NSAttributedString.Key: Any]
    {
        return [NSAttributedString.Key.font: UIFont(name: fontName + weight.rawValue, size: CGFloat(size)) ?? UIFont.systemFont(ofSize: CGFloat(size)),
                NSAttributedString.Key.foregroundColor: UIColor.black
        ]
    }

    static func attributedString(text: String, size: Int, weight: FontWeight, color: UIColor)-> NSAttributedString
    {
        let string = NSAttributedString(string: text, attributes: [
            NSAttributedString.Key.font: UIFont(name: fontName + weight.rawValue, size: CGFloat(size)) ?? UIFont.systemFont(ofSize: CGFloat(size)),
            NSAttributedString.Key.foregroundColor: color
            ])
        
        return string
    }
}
