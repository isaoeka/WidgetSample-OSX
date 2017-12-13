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

    override var nibName: NSNib.Name? {
        return NSNib.Name("TodayViewController")
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Update your data and prepare for a snapshot. Call completion handler when you are done
        // with NoData if nothing has changed or NewData if there is new data since the last
        // time we called you
        completionHandler(.noData)
    }

}
