//
//  TableViewController.swift
//  SimpleDS
//
//  Created by Amro Mousa on 7/18/15.
//  Copyright © 2015 Amro Mousa. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, DataSourceInjectable {

    var dataSource: DataSource? {
        didSet {
            dataSource?.registerForUpdates { [unowned self] (updatedItems: [DataSourceItem]) -> Void in
                let indexPaths = updatedItems.map({ (item: DataSourceItem) -> NSIndexPath in
                    NSIndexPath(forItem: item.index, inSection: 0)
                })
                self.tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfItems ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        if let item = dataSource?.itemAtIndex(indexPath.row) {
            cell.textLabel?.text = item.displayText()
        }
        
        return cell
    }
}
