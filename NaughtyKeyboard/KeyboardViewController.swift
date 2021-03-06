//
//  KeyboardViewController.swift
//  NaughtyKeyboard
//
//  Created by Romain Pouclet on 2015-08-10.
//  Copyright (c) 2015 Perfectly-Cooked. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    let tableView = UITableView(frame: CGRectZero, style: .Plain)
    let nextKeyboardButton = UIButton.buttonWithType(.Custom) as! UIButton
    
    var strings: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextKeyboardButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        nextKeyboardButton.setTitle("Switch keyboard", forState: .Normal)
        nextKeyboardButton.addTarget(self, action: Selector("didTapNextKeyboardButton"), forControlEvents: .TouchUpInside)
        view.addSubview(nextKeyboardButton)
        
        let topButtonConstraint = NSLayoutConstraint(item: nextKeyboardButton, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 0)
        let leftButtonConstraint = NSLayoutConstraint(item: nextKeyboardButton, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0)
        view.addConstraints([ leftButtonConstraint, topButtonConstraint])

        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "StringCell")
        tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        let topConstraint = NSLayoutConstraint(item: tableView, attribute: .Top, relatedBy: .Equal, toItem: nextKeyboardButton, attribute: .Bottom, multiplier: 1.0, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: tableView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: tableView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: tableView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: 0)
        view.addConstraints([topConstraint, leftConstraint, bottomConstraint, rightConstraint])

        let path = NSBundle(forClass: self.dynamicType).pathForResource("blns", ofType: "json")!
        strings = NSJSONSerialization.JSONObjectWithData(NSData(contentsOfFile: path)!, options: NSJSONReadingOptions.allZeros, error: nil) as! [String]
        tableView.reloadData()
    }
    
    func didTapNextKeyboardButton() {
        advanceToNextInputMode()
    }
}

extension KeyboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let string = strings[indexPath.row]
        if let proxy  = textDocumentProxy as? UIKeyInput {
            proxy.insertText(string)
            proxy.insertText("\n")
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StringCell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = strings[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return strings.count
    }
}
