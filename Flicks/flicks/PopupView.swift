//
//  PopupControl.swift
//  flicks
//
//  Created by Vincent Le on 1/16/16.
//  Copyright © 2016 Vincent Le. All rights reserved.
//

import UIKit
import Cosmos

class PopupView: UIScrollView {
    
    @IBOutlet weak var titleLabel: UITextView!
    @IBOutlet weak var overviewLabel: UITextView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var releaseView: UILabel!
    @IBOutlet weak var genreView: UILabel!
    @IBOutlet weak var rating: CosmosView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    
}