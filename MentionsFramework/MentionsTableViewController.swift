//
//  MentionsTableViewController.swift
//  MentionsFramework
//
//  Created by Fahed Al-Ahmad on 4/17/19.
//  Copyright © 2019 Fahed Al-Ahmad. All rights reserved.
//

import UIKit

class MentionsTableViewController: UITableViewController {

    var mentions:[Mentions] = []
    var delegate:MentionsTableViewControllerProtocol!
    
    override init(style: UITableView.Style) {
        super.init(style: .plain)
        tableView.separatorInset = .zero
        
        tableView.backgroundColor = .white
        
        tableView.register(MentionsTableViewCell.self, forCellReuseIdentifier: "MentionsTableViewCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func searchForMention(keyword:String) {
//        let language = Localize.currentLanguage()
//
//        delegate.mentionSearching(isSearching: true)
//        APIClient.GetMentions(Keyword: keyword, PageNo: 0, PageSize: 0, Language: language) { (mentions, error) in
//            if error != nil
//            {
//                print(error!)
//                return
//            }
//
//            self.mentions.removeAll()
//            self.mentions = mentions
//            self.tableView.reloadData()
//            self.delegate.mentionSearching(isSearching: false)
//        }
    }
    
    func emptyMentions() {
        mentions = []
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return mentions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MentionsTableViewCell", for: indexPath) as! MentionsTableViewCell
        
        let mention = mentions[indexPath.row]
        cell.config(mentionImage: mention.Photo, mentionName: mention.Name)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mention = mentions[indexPath.row]
        delegate.selectedItem(mentionId: mention.MentionId, name: mention.Name)
    }

}
