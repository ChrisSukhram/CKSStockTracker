//
//  DetailStockViewController.swift
//  CKSStockTracker
//
//  Created by Chris Sukhram on 2/14/16.
//  Copyright © 2016 CKSMedia. All rights reserved.
//

import UIKit

class DetailStockViewController: UIViewController {

    var stock:Stock = Stock()
    
    @IBOutlet var stockLastPriceLabel: UILabel!
    @IBOutlet var stockCompanyLabel: UILabel!
    @IBOutlet var dayLowLabel: UILabel!
    @IBOutlet var dayHighLabel: UILabel!
    @IBOutlet var yearLowLabel: UILabel!
    @IBOutlet var yearHighLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = stock.symbol
        stockLastPriceLabel.text = String(format: "$%@", stock.lastTradePrice)
        stockCompanyLabel.text = stock.name  + " (\(stock.changePercent > 0 ? "+" : "")\(stock.changePercent)%)"
        dayLowLabel.text = stock.daysLow
        dayHighLabel.text = stock.daysHigh
        yearLowLabel.text = stock.yearLow
        yearHighLabel.text = stock.yearHigh
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
