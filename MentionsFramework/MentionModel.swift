//
//  MentionModel.swift
//  MentionsFramework
//
//  Created by Fahed Al-Ahmad on 4/17/19.
//  Copyright © 2019 Fahed Al-Ahmad. All rights reserved.
//

import Foundation

struct PostMention {
    let MentionId:Int
    var MentionIndex: Int
    var endMentionIndex: Int?
    var lengthMention: Int?
    var isSelected:Bool?
}

enum MentionViewStatus {
    case opened
    case closed
}

struct Mentions: Decodable {
    let AnswerId: Int?
    let MentionId:Int
    let CSId: Int
    let Name: String
    let TypeId: Int
    let Photo: String
    var MentionIndex: Int?
}
