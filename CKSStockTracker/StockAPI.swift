//
//  StockAPI.swift
//  CKSStockTracker
//
//  Created by Chris Sukhram on 2/11/16.
//  Copyright © 2016 CKSMedia. All rights reserved.
//

import Foundation

struct Stock {
    var symbol:String = "--"
    var name:String = "--"
    var lastTradePrice = "--"
    var changePercent:Double = 0
    var daysHigh = "--"
    var daysLow = "--"
    var yearHigh = "--"
    var yearLow = "--"
}

class StockAPI
{
    class func fetchStockForSymbol(symbols:[String], completion:(stocks:[Stock])->()) {
        var stockList:[Stock] = [Stock]()
        
        let urlPath = generatePathForSymbols(symbols)
        let url = NSURL(string: urlPath)

        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            //handle response
            do {
                var stock = Stock()
                if error == nil {
                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                    
                    //need to safely unwrap these
                    let query:NSDictionary = jsonResult!["query"] as! NSDictionary
                    let results:NSDictionary = query["results"] as! NSDictionary
                    
                    if let quotes:NSArray = results["quote"] as? NSArray {
                        for var quote in quotes
                        {
                            stock = self.configureStockWithQuote(quote as! NSDictionary)
                            stockList.append(stock)
                        }
                    }
                    else if let quote:NSDictionary = results["quote"] as? NSDictionary {
                        stock = self.configureStockWithQuote(quote)
                        stockList.append(stock)
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(stocks: stockList)
                    })
                }
            }
            catch{
                print("TODO: Handle Errors")
            }
        })
        task.resume()
    }
    
    class func configureStockWithQuote(quote:NSDictionary) -> Stock {
        var stock = Stock()

        if let symbol = quote["Symbol"] as? String{
            stock.symbol = symbol.uppercaseString
        }
        if let name = quote["Name"] as? String {
            stock.name = name
        }
        if let lastPrice = quote["LastTradePriceOnly"] as? String {
            stock.lastTradePrice = lastPrice
        }
        if let change = quote["Change"] as? String {
            if let changePercent = Double(change) {
                stock.changePercent = changePercent
            }
        }
        if let daysLow = quote["DaysLow"] as? String {
            stock.daysLow = daysLow
        }
        if let daysHigh = quote["DaysHigh"] as? String {
            stock.daysHigh = daysHigh
        }
        if let yearLow = quote["YearLow"] as? String {
            stock.yearLow = yearLow
        }
        if let yearHigh = quote["YearHigh"] as? String {
            stock.yearHigh = yearHigh
        }
        return stock
    }
    
    class func generatePathForSymbols(symbols:[String]) -> String {
        var symbolArray = symbols
        var symbolQuery = ""
        
        for var (index,symbol) in symbols.enumerate() {
            symbolArray[index] = "%22\(symbol)%22"
        }
        
        symbolQuery = symbolArray.joinWithSeparator(",")
        let urlPath = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quote%20where%20symbol%20in%20(\(symbolQuery))&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
        return urlPath
    }
}