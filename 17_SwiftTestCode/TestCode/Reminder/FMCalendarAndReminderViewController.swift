

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
//        view.addSubview(otherButton)
//        view.addSubview(popButton)
//        view.addSubview(reminderButton)
    }
    
    /// MARK: --- action
    @objc private func add(_ sender: UIButton) {
        addReminder()
    }
    
    @objc private func query(_ sender: UIButton) {
        queryReminder()
    }
    
    @objc private func remove(_ sender: UIButton) {
        removeReminder()
    }
    
    @objc private func other(_ sender: UIButton) {
    }
    
    @objc private func popAction(_ sender: UIButton) {
        
    }
    
    @objc private func reminderAction(_ sender: UIButton) {
        
    }
    
    
    private func addReminder() {
                
        let date = Date(timeInterval: 60, since: Date())
        let title = "reminder title 提醒事件标题"
        let eventDB = reminderManager.eventDB
        let test = EKEventStore()
        // 申请提醒权限
        requestAuthorized(.reminder) { (granted, error) in
            if granted {
                //创建一个提醒功能
                let reminder = EKReminder(eventStore: eventDB)
                //标题
                reminder.title = title
                //添加日历
                reminder.calendar = eventDB.defaultCalendarForNewReminders()
                var cal = NSCalendar.current
                cal.timeZone = NSTimeZone.system
                
                let flags: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
                var dateComp = cal.dateComponents(flags, from: date)
                dateComp.timeZone = NSTimeZone.system
                //开始时间
                reminder.startDateComponents = dateComp
                //到期时间
                reminder.dueDateComponents = dateComp
                reminder.priority = 1
                //添加一个车闹钟
                let alarm = EKAlarm(absoluteDate: date)
                reminder.addAlarm(alarm)
                
                do {
                    try eventDB.save(reminder, commit: true)
                    print("提醒添加成功 ---  success ---")
                } catch (let error) {
                    print("提醒添加失败 ---  error --- \(error)")
                }
                
            } else {
                print("没有添加事件的权限")
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    private func queryReminder() {
        //        reminderManager.eventDB.enumerateEvents(matching: <#T##NSPredicate#>) { (<#EKEvent#>, <#UnsafeMutablePointer<ObjCBool>#>) in
        //            <#code#>
        //        }
//        EKCalendar(for: .reminder, eventStore: reminderManager.eventDB)
//        let predicate = reminderManager.eventDB.predicateForReminders(in: <#T##[EKCalendar]?#>)
//        reminderManager.eventDB.events(matching: <#T##NSPredicate#>)
    }
    
    private func removeReminder() {
        
    }
    
    private func requestAuthorized(_ type: EKEntityType, completion: @escaping ((Bool, NSError?) -> Void)) {
        let eventStatus = EKEventStore.authorizationStatus(for: .reminder)
        if eventStatus == .authorized {
            completion(true, nil)
        } else if eventStatus == .notDetermined {
            reminderManager.eventDB.requestAccess(to: type) { (granted, error) in
                completion(granted, error as NSError?)
            }
        } else {
            let error = NSError(domain: NSCocoaErrorDomain, code: NSUserCancelledError, userInfo: [NSLocalizedDescriptionKey: "未授权"])
            completion(false, error)
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
    
    lazy var otherButton: UIButton = {
        let button = UIButton(frame: CGRect(x: (screenWidth - 200) / 2, y: 88 + 230, width: 200, height: 50))
        button.setTitle("其它", for: .normal)
        button.addTarget(self, action: #selector(other(_:)), for: .touchUpInside)
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
