//
//  MentionController.swift
//  MentionsFramework
//
//  Created by Fahed Al-Ahmad on 4/17/19.
//  Copyright © 2019 Fahed Al-Ahmad. All rights reserved.
//

import Foundation
import UIKit

class MentionController: NSObject
{
    var textViewArea: UITextView!
    
    var superController: UIViewController!
    var superView:UIView!
    
    var contentView: UIView!
    
    fileprivate let mentionView:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isUserInteractionEnabled = true
        v.backgroundColor = UIColor(white: 0, alpha: 0.5)
        v.isHidden = true
        return v
    }()
    
    fileprivate let activityIndicatorForMentions: UIActivityIndicatorView = {
        let av = UIActivityIndicatorView(style: .gray)
        av.translatesAutoresizingMaskIntoConstraints = false
        av.isHidden = true
        return av
    }()
    
    // fileprivate
    fileprivate var mentionViewHeightAnchor:NSLayoutConstraint!
    
    var mentionViewStatus:MentionViewStatus = .closed
    let mentionTableViewController = MentionsTableViewController(style: .plain)
    var answer:NSMutableAttributedString!
    var mentionText:String = ""
    var mentionKeyword:String?
    var mentions:[PostMention] = []
    var isAllSelected:Bool = false
    
    init(superController:UIViewController, contentView: UIView, textViewArea: UITextView) {
        super.init()
        self.superController = superController
        self.superView = superController.view
        self.contentView = contentView
        self.textViewArea = textViewArea
        
        let defaultAttributes: [NSAttributedString.Key: Any] = Config.mentionStringAttrubures(weight: .medium, size: 15)
        let attributesAnswer = NSMutableAttributedString(string: "", attributes: defaultAttributes)
        answer = attributesAnswer
        
        self.textViewArea.attributedText = Config.attributedString(text: "Type your answer", size: 13, weight: .medium, color: .lightGray)
        self.textViewArea.delegate = self
        mentionTableViewController.delegate = self
        
        // Setup views, autolayout
        setupView()
        setupConstrains()
    }
    
    fileprivate func setupView() {
        superView.addSubview(contentView)
        superView.addSubview(mentionView)
        contentView.addSubview(activityIndicatorForMentions)
    }
    
    fileprivate func setupConstrains() {
        
        NSLayoutConstraint.activate([
            activityIndicatorForMentions.trailingAnchor.constraint(equalTo: textViewArea.trailingAnchor, constant: 16),
            activityIndicatorForMentions.widthAnchor.constraint(equalToConstant: 25),
            activityIndicatorForMentions.heightAnchor.constraint(equalToConstant: 25),
            activityIndicatorForMentions.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
        
        NSLayoutConstraint.activate([
            mentionView.topAnchor.constraint(equalTo: superView.topAnchor),
            mentionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mentionView.bottomAnchor.constraint(equalTo: contentView.topAnchor),
            mentionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        
        mentionView.addSubview(mentionTableViewController.view)
        superController.addChild(mentionTableViewController)
        
        mentionTableViewController.view.translatesAutoresizingMaskIntoConstraints = false
        mentionTableViewController.view.isUserInteractionEnabled = true
        
        NSLayoutConstraint.activate([
                mentionTableViewController.view.leadingAnchor.constraint(equalTo: mentionView.leadingAnchor),
                mentionTableViewController.view.bottomAnchor.constraint(equalTo: mentionView.bottomAnchor),
                mentionTableViewController.view.trailingAnchor.constraint(equalTo: mentionView.trailingAnchor),
            ])
        mentionViewHeightAnchor = mentionTableViewController.view.heightAnchor.constraint(equalToConstant: 0)
        mentionViewHeightAnchor.isActive = true
        
    }
    
    func clearData() {
        mentionTableViewController.emptyMentions()
        mentionKeyword = nil
        closeMentionTableView()
        let defaultAttributes: [NSAttributedString.Key: Any] = Config.mentionStringAttrubures(weight: .medium, size: 15)
        let attributesAnswer = NSMutableAttributedString(string: "", attributes: defaultAttributes)
        answer = attributesAnswer
    }
    
}

// MARK:- UITextViewDelegate

extension MentionController: UITextViewDelegate
{
    
    fileprivate func appendAnswerValue(text: String)
    {
        let defaultAttributes: [NSAttributedString.Key: Any] = Config.mentionStringAttrubures(weight: .medium, size: 15)
        let attributesAnswer = NSMutableAttributedString(string: text, attributes: defaultAttributes)
        answer.append(attributesAnswer)
        textViewArea.attributedText = answer
    }
    
    fileprivate func appendAnswerValue(text: String, range: NSRange)
    {
        let defaultAttributes: [NSAttributedString.Key: Any] = Config.mentionStringAttrubures(weight: .medium, size: 15)
        let attributesAnswer = NSMutableAttributedString(string: text, attributes: defaultAttributes)
        
        let leftSideRange = NSMakeRange(0, range.location)
        let leftSideText = answer.attributedSubstring(from: leftSideRange)
        
        let rightSideRange = NSMakeRange(leftSideText.string.count, (answer.length - leftSideText.string.count))
        let rightSideText = answer.attributedSubstring(from: rightSideRange)
        
        answer = NSMutableAttributedString(string: "", attributes: defaultAttributes)
        answer.append(leftSideText)
        answer.append(attributesAnswer)
        answer.append(rightSideText)
        
    }
    
    fileprivate func deleteAllCharacters()
    {
        let defaultAttributes: [NSAttributedString.Key: Any] = Config.mentionStringAttrubures(weight: .medium, size: 15)
        let attributesAnswer = NSMutableAttributedString(string: "", attributes: defaultAttributes)
        answer = attributesAnswer
        
        mentions.removeAll()
        
        mentionTableViewController.emptyMentions()
        mentionKeyword = nil
        closeMentionTableView()
        
        isAllSelected = false
    }
    
    fileprivate func deleteCharacters(range: NSRange, mentionArrayIndex: Int)
    {
        answer.deleteCharacters(in: range)
        textViewArea.selectedRange = range
        mentions.remove(at: mentionArrayIndex)
        appendAnswerValue(text: "")
        
        for index in 0..<mentions.count
        {
            let mention = mentions[index]
            let position = range.location
            
            if position < mention.MentionIndex
            {
                decreaseIndex(mentionIndex: index, range: range)
            }
        }
    }
    
    fileprivate func increaseIndex(mentionIndex: Int, range: NSRange)
    {
        let length = range.length == 0 ? 1 : range.length
        mentions[mentionIndex].MentionIndex += length
        mentions[mentionIndex].endMentionIndex! += length
    }
    
    fileprivate func decreaseIndex(mentionIndex: Int, range: NSRange)
    {
        mentions[mentionIndex].MentionIndex -= range.length
        mentions[mentionIndex].endMentionIndex! -= range.length
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if answer.string.isEmpty
        {
            appendAnswerValue(text: "")
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if answer.string.isEmpty
        {
            textViewArea.attributedText = Config.attributedString(text: "Type your answer", size: 13, weight: .medium, color: .lightGray)
        }
    }
    
    func textViewDidChangeSelection(_ textView: UITextView)
    {
        if !answer.string.isEmpty
        {
            if textView.selectedTextRange?.start == textView.beginningOfDocument && textView.selectedTextRange?.end == textView.endOfDocument
            {
                isAllSelected = true
            }
            else
            {
                isAllSelected = false
            }
        }
        else
        {
            isAllSelected = false
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText string: String) -> Bool
    {
        
        if isAllSelected
        {
            deleteAllCharacters()
            return true
        }
        
        if mentionKeyword == nil
        {
            mentionKeyword = ""
        }
        
        for index in 0..<mentions.count
        {
            let mention = mentions[index]
            let position = range.location
            
            if position > mention.MentionIndex && position <= mention.endMentionIndex!
            {
                let mentionRange = NSRange(location: mention.MentionIndex, length:  mention.lengthMention!+1)
                deleteCharacters(range: mentionRange, mentionArrayIndex: index)
                
                if mentionViewStatus == .opened
                {
                    mentionTableViewController.emptyMentions()
                    mentionKeyword = nil
                    closeMentionTableView()
                }
                return true
            }
        }
        
        if range.location == answer.length
        {
            if string == "@" && (answer.string.isEmpty || textView.attributedText.string.last == " ")
            {
                if mentionViewStatus == .closed
                {
                    mentionTableViewController.searchForMention(keyword: mentionKeyword!)
                    openMentionTableView()
                    appendAnswerValue(text: string)
                    return false
                }
                else
                {
                    return false
                }
            }
            else
            {
                if mentionViewStatus == .opened
                {
                    mentionKeyword = "\(mentionKeyword!)\(string)"
                    mentionTableViewController.searchForMention(keyword: mentionKeyword!)
                }
                appendAnswerValue(text: string)
                return false
            }
        }
        else
        {
            let isBackSpace = strcmp(string, "\\b")//Check if the user is deleting
            
            if (isBackSpace == -92)
            {
                let lastAlphabet = textView.attributedText?.string.last
                
                if lastAlphabet == "@" && mentionViewStatus == .opened//Close the mentions search menu
                {
                    mentionTableViewController.emptyMentions()
                    mentionKeyword = nil
                    closeMentionTableView()
                }
                else
                {
                    if mentionViewStatus == .opened
                    {
                        mentionKeyword?.removeLast()
                        mentionTableViewController.searchForMention(keyword: mentionKeyword!)
                    }
                    else
                    {
                        for index in 0..<mentions.count
                        {
                            let mention = mentions[index]
                            let position = range.location
                            if position < mention.MentionIndex
                            {
                                decreaseIndex(mentionIndex: index, range: range)
                            }
                        }
                        answer.deleteCharacters(in: range)
                        textView.deleteBackward()
                    }
                }
                return false
            }
            else if (string == "@" && textView.attributedText.string.last == " ")
            {
                if mentionViewStatus == .closed
                {
                    mentionTableViewController.searchForMention(keyword: mentionKeyword!)
                    openMentionTableView()
                    appendAnswerValue(text: string)
                    return false
                }
                else
                {
                    return false
                }
            }
            else
            {
                for index in 0..<mentions.count
                {
                    let mention = mentions[index]
                    let position = range.location
                    if position < mention.MentionIndex
                    {
                        increaseIndex(mentionIndex: index, range: range)
                        appendAnswerValue(text: string, range: range)
                    }
                }
                
                return true
            }
        }
    }
    
    func mentionSearching(isSearching: Bool) {
        if isSearching
        {
            activityIndicatorForMentions.isHidden = false
            activityIndicatorForMentions.startAnimating()
        }
        else
        {
            activityIndicatorForMentions.isHidden = true
            activityIndicatorForMentions.stopAnimating()
        }
    }
    
}

// MARK:- MentionsTableViewControllerProtocol
extension MentionController: MentionsTableViewControllerProtocol
{
    func selectedItem(mentionId: Int, name: String)
    {
        let indexOfAt = answer.string.firstIndex(of: "@")
        let range = answer.string.distance(from: answer.string.startIndex, to: indexOfAt!)
        
        let mentionPost = PostMention(MentionId: mentionId, MentionIndex: range, endMentionIndex: (range + name.count), lengthMention: name.count, isSelected: false)
        
        mentions.append(mentionPost)
        
        answer.deleteCharacters(in: NSMakeRange(range, mentionKeyword!.count+1))
        
        let mention = Config.attributedString(text: "\(name)", size: 17, weight: .heavy, color: .primaryColor)
        
        answer.append(mention)
        
        appendAnswerValue(text: " ")
        
        mentionTableViewController.emptyMentions()
        mentionKeyword = nil
        closeMentionTableView()
    }
    
    fileprivate func openMentionTableView()
    {
        mentionViewHeightAnchor.constant = 200
        mentionViewStatus = .opened
        mentionView.isHidden = false
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.superView.layoutIfNeeded()
        }, completion: nil)
    }
    
    fileprivate func closeMentionTableView()
    {
        mentionViewHeightAnchor.constant = 0
        mentionViewStatus = .closed
        mentionView.isHidden = true
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.superView.layoutIfNeeded()
        }, completion: nil)
    }
}
