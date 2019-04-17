//
//  MentionProtocols.swift
//  MentionsFramework
//
//  Created by Fahed Al-Ahmad on 4/17/19.
//  Copyright © 2019 Fahed Al-Ahmad. All rights reserved.
//

import Foundation

protocol MentionsTableViewControllerProtocol {
    func mentionSearching(isSearching: Bool)
    func selectedItem(mentionId: Int, name: String)
}
