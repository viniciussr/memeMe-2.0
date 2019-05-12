//
//  ViewMememeController.swift
//  memeMe
//
//  Created by Vinicius Rocha on 5/11/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

import UIKit

class ViewMememeController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var meme: Meme!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = meme.memedImage
        
    }
    
}
