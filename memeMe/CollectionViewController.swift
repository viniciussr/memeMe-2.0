//
//  CollectionViewController.swift
//  memeMe
//
//  Created by Vinicius Rocha on 5/9/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

import UIKit

class CollectionViewController: UICollectionViewController{
    
   
    @IBOutlet var layout: UICollectionView!
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        self.collectionView?.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionView", for: indexPath) as! ItemCollectionView
        cell.imageView.image = memes[indexPath.row].memedImage
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detail = self.storyboard?.instantiateViewController(withIdentifier: "ViewMememeController") as! ViewMememeController
        detail.meme = self.memes[indexPath.row]
        
        self.navigationController?.pushViewController(detail, animated: true)
    }
}
