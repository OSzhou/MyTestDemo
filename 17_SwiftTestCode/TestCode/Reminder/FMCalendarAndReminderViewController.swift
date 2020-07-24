

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
//        view.addSubview(otherButton)
//        view.addSubview(popButton)
//        view.addSubview(reminderButton)
    }
    
    /// MARK: --- action
    @objc private func add(_ sender: UIButton) {
        addReminder()
    }
    
    @objc private func query(_ sender: UIButton) {
        queryReminder({ (_) in
            
        })
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
    
    private func ggCalendar() -> EKCalendar? {
        if currentCalendar == nil {
            var shouldAdd = true
            var calendar = reminderManager.eventStore.calendars(for: .reminder).first(where: {
                if $0.title == "com.gg.calender" {
                    shouldAdd = false
                    return true
                }
                return false
            })
            if shouldAdd {
                var localSource: EKSource?
                // 真机
                localSource = reminderManager.eventStore.sources.first(where: {
                    //获取iCloud源
                    return ($0.sourceType == .calDAV && $0.title == "iCloud")
                })
                
                if localSource == nil {
                    // 模拟器
                    localSource = reminderManager.eventStore.sources.first(where: {
                        //获取本地Local源(就是模拟器中名为的Default的日历源)
                        return ($0.sourceType == .local)
                    })
                }
                
                let cal = EKCalendar(for: .reminder, eventStore: reminderManager.eventStore)
                cal.source = localSource
                cal.title = "com.gg.calender"
                do {
                    try reminderManager.eventStore.saveCalendar(cal, commit: true)
                    calendar = cal
                } catch (let error) {
                    print(" --- 日历创建失败 --- \(error)")
                }
                
            }
            return calendar
        }
        return currentCalendar
    }
    
    private func repeatRule(_ repeatIndex: NSInteger, currentDate: Date) -> EKRecurrenceRule? {
        guard let gregorian = NSCalendar(calendarIdentifier: .gregorian) else { return nil }
        
        var components = gregorian.components([.era, .year, .month, .day, .hour, .minute, .second], from: currentDate)
        components.year! += 1
        guard let recurrenceEndDate = gregorian.date(from: components) else { return nil }
        
        var components2 = gregorian.components([.era, .year, .month, .day, .hour, .minute, .second], from: currentDate)
        components2.year! += 3
        guard let recurrenceEndDate2 = gregorian.date(from: components2) else { return nil }
        
        var rule: EKRecurrenceRule?
        switch repeatIndex {
        case 0: // 每天
            rule = EKRecurrenceRule(recurrenceWith: .daily, interval: 1, daysOfTheWeek: nil, daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: EKRecurrenceEnd(end: recurrenceEndDate))
        case 1: // 每两天
            rule = EKRecurrenceRule(recurrenceWith: .daily, interval: 2, daysOfTheWeek: nil, daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: EKRecurrenceEnd(end: recurrenceEndDate))
        case 2: // 每周
            rule = EKRecurrenceRule(recurrenceWith: .weekly, interval: 1, daysOfTheWeek: nil, daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: EKRecurrenceEnd(end: recurrenceEndDate2))
        case 3: // 每月
            rule = EKRecurrenceRule(recurrenceWith: .monthly, interval: 1, daysOfTheWeek: nil, daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: EKRecurrenceEnd(end: recurrenceEndDate2))
        case 4: // 每年
            rule = EKRecurrenceRule(recurrenceWith: .yearly, interval: 1, daysOfTheWeek: nil, daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: EKRecurrenceEnd(end: recurrenceEndDate2))
        case 5: // 工作日
            rule = EKRecurrenceRule(recurrenceWith: .daily, interval: 1, daysOfTheWeek: [EKRecurrenceDayOfWeek(dayOfTheWeek: .monday, weekNumber: 1), EKRecurrenceDayOfWeek(dayOfTheWeek: .tuesday, weekNumber: 2), EKRecurrenceDayOfWeek(dayOfTheWeek: .wednesday, weekNumber: 3), EKRecurrenceDayOfWeek(dayOfTheWeek: .thursday, weekNumber: 4), EKRecurrenceDayOfWeek(dayOfTheWeek: .friday, weekNumber: 5)], daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: EKRecurrenceEnd(end: recurrenceEndDate))
        case 6:
            rule = nil
        default:
            break
        }
        return rule
    }
    //@[@"当事件发生时",@"5分钟前",@"15分钟前",@"30分钟前",@"1小时前",@"1天前",@"不提醒"]
    private func alarmSetting(_ reminderIndex: NSInteger) -> EKAlarm? {
        var alarm: EKAlarm?
        switch reminderIndex {
        case 0:
            alarm = EKAlarm(relativeOffset: 0)
        case 1:
            alarm = EKAlarm(relativeOffset: -60 * 5)
        case 2:
            alarm = EKAlarm(relativeOffset: -60 * 15)
        case 3:
            alarm = EKAlarm(relativeOffset: -60 * 30)
        case 4:
            alarm = EKAlarm(relativeOffset: -60 * 60)
        case 5:
            alarm = EKAlarm(relativeOffset: -60 * 60 * 24)
        case 6:
            alarm = nil
        default:
            break
        }
        return alarm
    }
    
    private func addReminder(_ title: String, startDate: Date, endDate: Date, repeatIndex: NSInteger, remindIndexs: [Int], notes: String) {
        let eventStore = reminderManager.eventStore
        //创建一个新提醒
        let reminder = EKReminder(eventStore: eventStore)
        reminder.title = title
        //添加日历
        reminder.calendar = ggCalendar()
        var cal = NSCalendar.current
        cal.timeZone = NSTimeZone.system
        
        let flags: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        var sDateComp = cal.dateComponents(flags, from: startDate)
        sDateComp.timeZone = NSTimeZone.system
        //开始时间
        reminder.startDateComponents = sDateComp
        var eDateComp = cal.dateComponents(flags, from: endDate)
        eDateComp.timeZone = NSTimeZone.system
        //到期时间
        reminder.dueDateComponents = eDateComp
        //重复规则
        if let rule = repeatRule(repeatIndex, currentDate: startDate) {
            reminder.recurrenceRules = [rule]
        } else {
            reminder.recurrenceRules = nil
        }
        //设置提醒
        for i in remindIndexs {
            if let alarm = alarmSetting(i) {
                reminder.addAlarm(alarm)
            }
        }
 
        
        //备注
        reminder.notes = notes
        
        reminder.priority = 1
        
        do {
            try eventStore.save(reminder, commit: true)
            print("提醒添加成功 ---  success ---")
        } catch (let error) {
            print("提醒添加失败 ---  error --- \(error)")
        }
    }
    
    private func addReminder() {
                
        let date = Date(timeInterval: 60 * 6, since: Date())
        let title = "reminder title 提醒事件标题"
        
        // 申请提醒权限
        requestAuthorized(.reminder) { (granted, error) in
            if granted {
                /*//创建一个提醒功能
                let reminder = EKReminder(eventStore: eventStore)
                //标题
                reminder.title = title
                //添加日历
                reminder.calendar = eventStore.defaultCalendarForNewReminders()
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
                //添加一个闹钟
                let alarm = EKAlarm(absoluteDate: date)
                reminder.addAlarm(alarm)
                
                do {
                    try eventStore.save(reminder, commit: true)
                    print("提醒添加成功 ---  success ---")
                } catch (let error) {
                    print("提醒添加失败 ---  error --- \(error)")
                }*/
                
                self.addReminder(title, startDate: date, endDate: date, repeatIndex: 0, remindIndexs: [1], notes: "reminder 测试事件")
                
            } else {
                print("没有添加事件的权限")
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    private func queryReminder(_ completion: @escaping (([EKReminder]?) -> Void)) {
        //        reminderManager.eventStore.enumerateEvents(matching: <#T##NSPredicate#>) { (<#EKEvent#>, <#UnsafeMutablePointer<ObjCBool>#>) in
        //            <#code#>
        //        }
//        EKCalendar(for: .reminder, eventStore: reminderManager.eventStore)
//        let predicate = reminderManager.eventStore.predicateForReminders(in: <#T##[EKCalendar]?#>)
//        reminderManager.eventStore.events(matching: <#T##NSPredicate#>)
        let calendar = NSCalendar.current
        let oneDayAgoComponents = NSDateComponents()
        oneDayAgoComponents.day = -1
        let oneDayAgo = calendar.date(byAdding: oneDayAgoComponents as DateComponents, to: Date())
        let oneMonthFromNowComponents = NSDateComponents()
        oneMonthFromNowComponents.month = 1
        let oneMonthFromNow = calendar.date(byAdding: oneMonthFromNowComponents as DateComponents, to: Date())
        
        if let cal = ggCalendar() {
            let predicate = reminderManager.eventStore.predicateForIncompleteReminders(withDueDateStarting: oneMonthFromNow, ending: oneDayAgo, calendars: [cal])
            reminderManager.eventStore.fetchReminders(matching: predicate) { (reminders) in
                completion(reminders)
                print("query reminders --- \(reminders)")
            }
        }
        
    }
    
    private func removeReminder() {
        queryReminder({ (reminders) in
            if let items = reminders {
                for item in items {
                    do {
                        try self.reminderManager.eventStore.remove(item, commit: true)
                    } catch (let error) {
                        print("删除 提醒失败 --- error --- \(error)")
                    }
                }
            }
        })
    }
    
    private func requestAuthorized(_ type: EKEntityType, completion: @escaping ((Bool, NSError?) -> Void)) {
        let eventStatus = EKEventStore.authorizationStatus(for: type)
        if eventStatus == .authorized {
            completion(true, nil)
        } else if eventStatus == .notDetermined {
            reminderManager.eventStore.requestAccess(to: type) { (granted, error) in
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
