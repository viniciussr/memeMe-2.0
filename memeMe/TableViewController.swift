//
//  TableViewController.swift
//  memeMe
//
//  Created by Vinicius Rocha on 5/9/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

import UIKit


class TableViewController: UITableViewController {
    var memes: [Meme]!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memes  = (UIApplication.shared.delegate as! AppDelegate).memes
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 800
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell", for: indexPath) as! ItemTableViewCell
        let meme = memes[indexPath.row]
        
        cell.imageCell.image = meme.memedImage
        cell.label.text = meme.topText! + meme.bottomText!
        cell.label.lineBreakMode = NSLineBreakMode.byTruncatingMiddle
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memeView = self.storyboard?.instantiateViewController(withIdentifier: "ViewMememeController") as! ViewMememeController
        memeView.meme = self.memes[indexPath.row]
        self.navigationController?.pushViewController(memeView, animated: true)
    }
    
}
