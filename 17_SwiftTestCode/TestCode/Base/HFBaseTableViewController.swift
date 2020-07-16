//
//  HFBaseTableViewController.swift
//  TTC_Wallet_iOS
//
//  Created by 张良 on 2018/7/2.
//  Copyright © 2018年 tataufo. All rights reserved.
//

import UIKit
import MJRefresh

class HFBaseTableViewController: HFBaseViewController {

    fileprivate var tableviewStyle: UITableView.Style = .plain
    lazy var tableView: UITableView! = {
        return table(style: tableviewStyle)
    }()

    func table(style: UITableView.Style) -> UITableView {
        let frame = CGRect(x: 0, y: 0, width: Constants.ScreenWidth, height: Constants.ScreenHeight)
        let tableView = UITableView(frame: frame, style: style)

        /// 点击高亮效果
        tableView.delaysContentTouches = false

//        let edgeInsets = UIEdgeInsets(top: Constants.NavAndStatusBarHeight, left: 0, bottom: Constants.BottomSafeMargin, right: 0)
//        tableView.contentInset = edgeInsets
//
//        let indicatorInsets = UIEdgeInsets(top: Constants.NavAndStatusBarHeight, left: 0, bottom: 0, right: 0)
//        tableView.scrollIndicatorInsets = indicatorInsets

        tableView.separatorStyle = .none
        tableView.fitIOS11()
        return tableView
    }

    func addTableview(superview: UIView, style: UITableView.Style = .plain, config: ((UITableView) -> Void)? ) {

        tableviewStyle = style

        superview.addSubview(tableView)

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier())

        config?(tableView)
    }

    
    func addFooter(block: (() -> Void)?) {
        let footer = MJRefreshAutoStateFooter.init {
            block?()
        }
        
        footer.stateLabel?.font = UIFont.systemFont(ofSize: 13)
        footer.stateLabel?.textColor = .gray
        footer.setTitle("", for: .idle)
        footer.setTitle("—  正在努力加载  —", for: .refreshing)
        footer.setTitle("再刷也没有啦", for: .noMoreData)
        self.tableView.mj_footer = footer
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HFBaseTableViewController: UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier())!
    }
}

extension HFBaseTableViewController: UITableViewDelegate {

}
