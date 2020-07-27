

//
//  FMRootViewController.swift
//  TestCode
//
//  Created by Zhouheng on 2020/6/3.
//  Copyright © 2020 tataUFO. All rights reserved.
//

import UIKit
import EventKit


class FMCalendarAndReminderViewController: UIViewController {
    
    let reminderManager = GGRminderManager()

    var currentCalendar: EKCalendar?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .gray
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(addButton)
        view.addSubview(queryButton)
        view.addSubview(removeButton)
        view.addSubview(editButton)
//        view.addSubview(popButton)
//        view.addSubview(reminderButton)
    }
    
    /// MARK: --- action
    @objc private func add(_ sender: UIButton) {
        addReminder()
    }
    
    @objc private func query(_ sender: UIButton) {
        reminderManager.queryReminder { (_) in
            
        }
    }
    
    @objc private func remove(_ sender: UIButton) {
        reminderManager.removeReminder("E17FFAAD-3B65-4E42-98BF-71CD4EC667C0")
    }
    
    @objc private func edit(_ sender: UIButton) {
        reminderManager.updateReminder("E17FFAAD-3B65-4E42-98BF-71CD4EC667C0")
    }
    
    @objc private func popAction(_ sender: UIButton) {
        
    }
    
    @objc private func reminderAction(_ sender: UIButton) {
        
    }
    
    private func addReminder() {
                
        let sDate = Date(timeInterval: 60 * 10, since: Date())
        let eDate = Date(timeInterval: 60 * 20, since: Date())
        let title = "reminder title 提醒事件标题"
        
        // 申请提醒权限
        reminderManager.requestAuthorized(.reminder) { [weak self] (granted, error) in
            guard let `self` = self else { return }
            if granted {
                self.reminderManager.createReminder(title, startDate: sDate, endDate: eDate, repeatIndex: 0, remindIndexs: [0, 1, 2], notes: "reminder 测试事件")
            } else {
                print("没有添加事件的权限")
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        
    }
    
    /// MARK: --- lazy loading
    lazy var addButton: UIButton = {
        let button = UIButton(frame: CGRect(x: (screenWidth - 200) / 2, y: 88 + 50, width: 200, height: 50))
        button.setTitle("添加提醒", for: .normal)
        button.addTarget(self, action: #selector(add(_:)), for: .touchUpInside)
        button.backgroundColor = .gray
        return button
    }()
    
    lazy var queryButton: UIButton = {
        let button = UIButton(frame: CGRect(x: (screenWidth - 200) / 2, y: 88 + 110, width: 200, height: 50))
        button.setTitle("查找提醒", for: .normal)
        button.addTarget(self, action: #selector(query(_:)), for: .touchUpInside)
        button.backgroundColor = .gray
        return button
    }()
    
    lazy var removeButton: UIButton = {
        let button = UIButton(frame: CGRect(x: (screenWidth - 200) / 2, y: 88 + 170, width: 200, height: 50))
        button.setTitle("删除提醒", for: .normal)
        button.addTarget(self, action: #selector(remove(_:)), for: .touchUpInside)
        button.backgroundColor = .gray
        return button
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton(frame: CGRect(x: (screenWidth - 200) / 2, y: 88 + 230, width: 200, height: 50))
        button.setTitle("修改提醒", for: .normal)
        button.addTarget(self, action: #selector(edit(_:)), for: .touchUpInside)
        button.backgroundColor = .gray
        return button
    }()
    
    lazy var popButton: UIButton = {
        let button = UIButton(frame: CGRect(x: (screenWidth - 200) / 2, y: 88 + 290, width: 200, height: 50))
        button.setTitle("弹框", for: .normal)
        button.addTarget(self, action: #selector(popAction(_:)), for: .touchUpInside)
        button.backgroundColor = .gray
        return button
    }()
    
    lazy var reminderButton: UIButton = {
        let button = UIButton(frame: CGRect(x: (screenWidth - 200) / 2, y: 88 + 360, width: 200, height: 50))
        button.setTitle("提醒", for: .normal)
        button.addTarget(self, action: #selector(reminderAction(_:)), for: .touchUpInside)
        button.backgroundColor = .gray
        return button
    }()
}
