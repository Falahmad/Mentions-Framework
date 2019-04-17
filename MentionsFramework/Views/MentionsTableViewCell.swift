//
//  MentionsTableViewCell.swift
//  MentionsFramework
//
//  Created by Fahed Al-Ahmad on 4/17/19.
//  Copyright © 2019 Fahed Al-Ahmad. All rights reserved.
//

import UIKit

class MentionsTableViewCell: UITableViewCell {

    fileprivate let mentionImage:UIImageView = {
        let mv = UIImageView()
        mv.translatesAutoresizingMaskIntoConstraints = false
        mv.layer.cornerRadius = 25/2
        mv.clipsToBounds = true
        mv.widthAnchor.constraint(equalToConstant: 25).isActive = true
        mv.heightAnchor.constraint(equalToConstant: 25).isActive = true
        return mv
    }()
    
    fileprivate let mentionName:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(mentionImage)
        addSubview(mentionName)
        
        mentionImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        mentionImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        mentionName.leadingAnchor.constraint(equalTo: mentionImage.trailingAnchor, constant: 8).isActive = true
        mentionName.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
    }
    
    func config(mentionImage:String, mentionName: String) {
        
//        mentionImage.loadImageUsingCacheWithUrlString(mentionImage)
        self.mentionName.attributedText = Config.attributedString(text: mentionName, size: 14, weight: .heavy, color: .black)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
