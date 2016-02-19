//
//  BasicStockTableViewCell.swift
//  CKSStockTracker
//
//  Created by Chris Sukhram on 2/11/16.
//  Copyright © 2016 CKSMedia. All rights reserved.
//

import UIKit

class BasicStockTableViewCell: UITableViewCell {

    @IBOutlet var lastTradedPriceLabel: UILabel!
    @IBOutlet var symbolLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        if highlighted {
            self.layer.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3).CGColor
        }
        else {
            self.layer.backgroundColor = UIColor.whiteColor().CGColor
        }
    }
}
