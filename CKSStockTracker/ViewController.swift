//
//  ViewController.swift
//  CKSStockTracker
//
//  Created by Chris Sukhram on 2/8/16.
//  Copyright © 2016 CKSMedia. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var stocksTableView: UITableView!
    
    var refreshController:UIRefreshControl!
    
    var tableData:[Stock] = [Stock]()
    var watchList:[String] = ["TSLA", "GOOGL", "YHOO", "AAPL", "HPE", "JCP","MSFT","WFC", "BAC"]
    //var watchList:[String] = ["TSLA"]
    var selectedStock:Stock = Stock()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshController = UIRefreshControl()
        refreshController.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        stocksTableView.addSubview(refreshController)
        
        stocksTableView.delegate = self
        stocksTableView.dataSource = self
        
        for var symbol in watchList {
            var stock = Stock()
            stock.symbol = symbol
            tableData.append(stock)
        }
        stocksTableView.reloadData()
    
        refreshData()
    }
    
    func refreshData() {
        StockAPI.fetchStockForSymbol(watchList) { (stockList) -> () in
            self.tableData = stockList
            self.stocksTableView.reloadData()
        }
        self.refreshController.endRefreshing()
    }
    
    func refresh(refreshControl:UIRefreshControl) {
        refreshData()
    }
    
    @IBAction func addWatchlistItem(sender: AnyObject) {
        //Temporary way to add stocks for demonstration. Will later turn into a separate view controller with a live search bar.
        let alertController = UIAlertController(title: "Add Stock", message: "Add a ticker symbol to your watch list", preferredStyle: .Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (addSymbolTextField) -> Void in
            addSymbolTextField.placeholder = "TSLA, GOOGL, ..."
        }
        
        alertController.addAction(UIAlertAction(title: "Add", style: .Default, handler: { (alertAction) -> Void in
            if let symbolTextField = alertController.textFields?.first{
                if let symbols = symbolTextField.text?.characters.split(",").map(String.init) {
                    for symbol in symbols {
                        self.watchList.append(symbol.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))
                    }
                }
            }
            self.refreshData()
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (alertAction) -> Void in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alertController, animated: true) { () -> Void in
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedStock = tableData[indexPath.row]
        self.performSegueWithIdentifier("showStockSegue", sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StockCell", forIndexPath: indexPath) as! BasicStockTableViewCell
        
        let stock = tableData[indexPath.row]
        
        cell.symbolLabel?.text = stock.symbol
        cell.nameLabel?.text = stock.name
        cell.lastTradedPriceLabel.text? = stock.lastTradePrice
        
        //Will use my custom theme class here
        cell.lastTradedPriceLabel.layer.cornerRadius = 10
        cell.lastTradedPriceLabel.layer.masksToBounds = true
        
        if stock.changePercent >= 0 {
            cell.lastTradedPriceLabel.textColor = UIColor(red:62/255.0, green: 202/255.0, blue: 98/255.0, alpha: 1)
        }
        else if stock.changePercent < 0 {
            cell.lastTradedPriceLabel.textColor = UIColor(red: 202/255.0, green: 62/255.0, blue: 62/255.0, alpha: 1)
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showStockSegue" {
            let destinationVC = segue.destinationViewController as! DetailStockViewController
            destinationVC.stock = selectedStock
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
