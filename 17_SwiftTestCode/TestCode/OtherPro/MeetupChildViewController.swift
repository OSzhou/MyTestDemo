//
//  MeetupChildViewController.swift
//  TestCode
//
//  Created by Zhouheng on 2020/7/15.
//  Copyright © 2020 tataUFO. All rights reserved.
//

import UIKit

class MeetupChildViewController: HFBaseTableViewController {
    let headerH: CGFloat = 88 + 52.5 + 50
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: CGFloat(arc4random_uniform(255)) / 255.0, green: CGFloat(arc4random_uniform(255)) / 255.0, blue: CGFloat(arc4random_uniform(255)) / 255.0, alpha: 1.0)
        self.createUI()
        self.getData()
    }
    
    func getData() {
        
    }
    
    func createUI() {
        
        addTableview(superview: view, style: .plain) { [weak self] (tableview) in
            guard let self = self else { return }
            tableview.frame = CGRect(x: 0, y: 0, width: Constants.ScreenWidth, height: Constants.ScreenHeight - self.headerH)
            tableview.dataSource = self
            tableview.delegate = self
            tableview.backgroundColor = UIColor.clear
            
            tableview.tableHeaderView = self.headerView
            
//            tableview.register(MeetupPassOrRejectTableViewCell.self, forCellReuseIdentifier: MeetupPassOrRejectTableViewCell.identifier())
            tableview.register(MeetupWaitingTableViewCell.self, forCellReuseIdentifier: MeetupWaitingTableViewCell.identifier())
        }
                
    }
        
    /// MARK: --- lazy loading
    lazy var headerView: MeetupTableViewHeader = {
        let view = MeetupTableViewHeader(frame: CGRect(x: 0, y: 0, width: Constants.ScreenWidth, height: 50))
        return view
    
    }()
    
}

extension MeetupChildViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MeetupWaitingTableViewCell.identifier()) as! MeetupWaitingTableViewCell
//        let cell = tableView.dequeueReusableCell(withIdentifier: MeetupPassOrRejectTableViewCell.identifier()) as! MeetupPassOrRejectTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 77
        
    }
    
}
