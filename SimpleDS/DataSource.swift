//
//  DataSource.swift
//  SimpleDS
//
//  Created by Amro Mousa on 7/18/15.
//  Copyright © 2015 Amro Mousa. All rights reserved.
//

import UIKit

protocol DataSourceInjectable {
    var dataSource: DataSource? { get set }
}

protocol DataSourceItem {
    var index: Int { get }
    func displayText() -> String
}

typealias DataSourceCallback = (updatedItems: [DataSourceItem]) -> Void

protocol DataSource {
    var callback: DataSourceCallback? { get set }
    var numberOfItems: Int { get }
    func itemAtIndex(index: Int) -> DataSourceItem
    func registerForUpdates(callback: DataSourceCallback) -> Void
}

//This could just implement UITableViewDataSource
class ThingDataSource : DataSource {
    var content: [Thing]
    var callback: DataSourceCallback?
    var timer: NSTimer!
    
    init() {
        content = (0...29).map { Thing(index: $0) }
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("tick"), userInfo: nil, repeats: true)
    }
    
    //Simulate mutation from an external source (e.g. user editing an entry
    @objc func tick() {
        let numberOfItemsToChange = Int(arc4random_uniform(UInt32(5)))
        var updatedItems: [DataSourceItem] = []

        for _ in 0...numberOfItemsToChange {
            let randomIndex = arc4random_uniform(UInt32(content.count))
            var item = content[Int(randomIndex)]
            item.text = "Thing \(item.index) : \(arc4random_uniform(UInt32(1000)))"
            content[item.index] = item
            updatedItems.append(item)
        }
        
        if let callback = callback {
            callback(updatedItems: updatedItems)
        }
    }
    
    var numberOfItems : Int {
        get {
            return content.count
        }
    }
    
    func itemAtIndex(index: Int) -> DataSourceItem {
        return content[index]
    }

    func registerForUpdates(callback: DataSourceCallback) -> Void {
        self.callback = callback
    }
}

struct Thing : DataSourceItem {
    var index: Int // doubles as ID for our little sample
    var text: String
    
    init(index: Int) {
        self.index = index
        self.text = "Thing \(index)"
    }
    
    func displayText() -> String {
        return text
    }
}

