//
//  TodayViewController.swift
//  TodayExtension
//
//  Created by Isao Kono on 2017/12/14.
//  Copyright © 2017年 isaoeka. All rights reserved.
//

import Cocoa
import NotificationCenter
import Alamofire
import SwiftyJSON

class TodayViewController: NSViewController, NCWidgetProviding {
    static let qiitaToken: String = "XXXX"

    @IBOutlet weak private var scrollView: NSScrollView!
    @IBOutlet weak private var tableView: NSTableView!

    struct QiitaItem {
        let title: String
        let url: String
        let userId: String
    }
    private var items: [QiitaItem] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

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
        self.fetchData()
        // Update your data and prepare for a snapshot. Call completion handler when you are done
        // with NoData if nothing has changed or NewData if there is new data since the last
        // time we called you
        completionHandler(.noData)
    }

    private func fetchData() {
        let url: String = "https://qiita.com/api/v2/items"
        Alamofire.request(url,
                          method: .get,
                          parameters: [
                            "page": 1,
                            "pre_page": 20,
                            "query": "tag:Swift"
            ],
                          headers: [
                            "Authorization": " Bearer \(TodayViewController.qiitaToken)",
            ]
            ).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.items = json.map { (_, json) in
                        QiitaItem(
                            title: json["title"].string ?? "",
                            url: json["url"].string ?? "",
                            userId: json["user"]["id"].string ?? ""
                        )
                    }
                case .failure(let error):
                    print(error)
                }
        }
    }
}

extension TodayViewController: NSTableViewDelegate, NSTableViewDataSource {

    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.items.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), owner: self),
            let cell = view as? NSTableCellView
            else {
                return nil
        }
        let item = self.items[row]
        cell.textField?.stringValue = item.title
        return cell
    }

    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        let item = self.items[row]
        print(item)

        if let url = URL(string: item.url) {
            NSWorkspace.shared.open(url)
        }

        return true
    }
}
