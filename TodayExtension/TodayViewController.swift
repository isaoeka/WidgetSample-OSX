//
//  TodayViewController.swift
//  TodayExtension
//
//  Created by Isao Kono on 2017/12/14.
//  Copyright © 2017年 isaoeka. All rights reserved.
//

import Cocoa
import NotificationCenter

class TodayViewController: NSViewController, NCWidgetProviding {

    @IBOutlet weak private var scrollView: NSScrollView!
    @IBOutlet weak private var tableView: NSTableView!

    override var nibName: NSNib.Name? {
        return NSNib.Name("TodayViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollView.drawsBackground = false

        self.tableView.headerView = nil
        self.tableView.backgroundColor = .clear
        self.tableView.selectionHighlightStyle = .sourceList
        self.tableView.gridColor = .lightGray
        self.tableView.gridStyleMask = .solidHorizontalGridLineMask
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Update your data and prepare for a snapshot. Call completion handler when you are done
        // with NoData if nothing has changed or NewData if there is new data since the last
        // time we called you
        completionHandler(.noData)
    }
}

extension TodayViewController: NSTableViewDelegate, NSTableViewDataSource {

    func numberOfRows(in tableView: NSTableView) -> Int {
        return 10
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), owner: self),
            let cell = view as? NSTableCellView
            else {
                return nil
        }

        cell.textField?.stringValue = "----- CELL ----"
        return cell
    }
}


