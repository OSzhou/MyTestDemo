//
//  GGRminderManager.swift
//  TestCode
//
//  Created by Smile on 2020/7/24.
//  Copyright © 2020 tataUFO. All rights reserved.
//

import UIKit
import EventKit

class GGReminderManager: NSObject {
    
    static let shared: GGReminderManager = GGRminderManager()
    let eventStore = EKEventStore()
    var currentCalendar: EKCalendar?
    
    private func ggCalendar(_ title: String = "com.gg.calendar") -> EKCalendar? {
        if currentCalendar == nil {
            var shouldAdd = true
            var calendar = eventStore.calendars(for: .reminder).first(where: {
                if $0.title == title {
                    shouldAdd = false
                    return true
                }
                return false
            })
            if shouldAdd {
                var localSource: EKSource?
                // 真机
                localSource = eventStore.sources.first(where: {
                    //获取iCloud源
                    return ($0.sourceType == .calDAV && $0.title == "iCloud")
                })
                
                if localSource == nil {
                    // 模拟器
                    localSource = eventStore.sources.first(where: {
                        //获取本地Local源(就是模拟器中名为的Default的日历源)
                        return ($0.sourceType == .local)
                    })
                }
                
                let cal = EKCalendar(for: .reminder, eventStore: eventStore)
                cal.source = localSource
                cal.title = title
                do {
                    try eventStore.saveCalendar(cal, commit: true)
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
        
        var components = gregorian.components([.era,
                                               .year,
                                               .month,
                                               .day,
                                               .hour,
                                               .minute,
                                               .second],from: currentDate)
        components.year! += 1
        guard let recurrenceEndDate = gregorian.date(from: components) else { return nil }
        
        var components2 = gregorian.components([.era,
                                                .year,
                                                .month,
                                                .day,
                                                .hour,
                                                .minute,
                                                .second], from: currentDate)
        components2.year! += 3
        guard let recurrenceEndDate2 = gregorian.date(from: components2) else { return nil }
        
        var rule: EKRecurrenceRule?
        switch repeatIndex {
        case 0: // 每天
            rule = EKRecurrenceRule(recurrenceWith: .daily,
                                    interval: 1,
                                    daysOfTheWeek: nil,
                                    daysOfTheMonth: nil,
                                    monthsOfTheYear: nil,
                                    weeksOfTheYear: nil,
                                    daysOfTheYear: nil,
                                    setPositions: nil,
                                    end: EKRecurrenceEnd(end: recurrenceEndDate))
        case 1: // 每两天
            rule = EKRecurrenceRule(recurrenceWith: .daily,
                                    interval: 2,
                                    daysOfTheWeek: nil,
                                    daysOfTheMonth: nil,
                                    monthsOfTheYear: nil,
                                    weeksOfTheYear: nil,
                                    daysOfTheYear: nil,
                                    setPositions: nil,
                                    end: EKRecurrenceEnd(end: recurrenceEndDate))
        case 2: // 每周
            rule = EKRecurrenceRule(recurrenceWith: .weekly,
                                    interval: 1,
                                    daysOfTheWeek: nil,
                                    daysOfTheMonth: nil,
                                    monthsOfTheYear: nil,
                                    weeksOfTheYear: nil,
                                    daysOfTheYear: nil,
                                    setPositions: nil,
                                    end: EKRecurrenceEnd(end: recurrenceEndDate2))
        case 3: // 每月
            rule = EKRecurrenceRule(recurrenceWith: .monthly,
                                    interval: 1,
                                    daysOfTheWeek: nil,
                                    daysOfTheMonth: nil,
                                    monthsOfTheYear: nil,
                                    weeksOfTheYear: nil,
                                    daysOfTheYear: nil,
                                    setPositions: nil,
                                    end: EKRecurrenceEnd(end: recurrenceEndDate2))
        case 4: // 每年
            rule = EKRecurrenceRule(recurrenceWith: .yearly,
                                    interval: 1,
                                    daysOfTheWeek: nil,
                                    daysOfTheMonth: nil,
                                    monthsOfTheYear: nil,
                                    weeksOfTheYear: nil,
                                    daysOfTheYear: nil,
                                    setPositions: nil,
                                    end: EKRecurrenceEnd(end: recurrenceEndDate2))
        case 5: // 工作日
            rule = EKRecurrenceRule(recurrenceWith: .daily,
                                    interval: 1,
                                    daysOfTheWeek: [EKRecurrenceDayOfWeek(dayOfTheWeek: .monday, weekNumber: 1),
                                                    EKRecurrenceDayOfWeek(dayOfTheWeek: .tuesday, weekNumber: 2),
                                                    EKRecurrenceDayOfWeek(dayOfTheWeek: .wednesday, weekNumber: 3),
                                                    EKRecurrenceDayOfWeek(dayOfTheWeek: .thursday, weekNumber: 4),
                                                    EKRecurrenceDayOfWeek(dayOfTheWeek: .friday, weekNumber: 5)],
                                    daysOfTheMonth: nil,
                                    monthsOfTheYear: nil,
                                    weeksOfTheYear: nil,
                                    daysOfTheYear: nil,
                                    setPositions: nil,
                                    end: EKRecurrenceEnd(end: recurrenceEndDate))
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
            alarm = EKAlarm(relativeOffset: 60 * 5)
        case 2:
            alarm = EKAlarm(relativeOffset: 60 * 15)
        case 3:
            alarm = EKAlarm(relativeOffset: 60 * 30)
        case 4:
            alarm = EKAlarm(relativeOffset: 60 * 60)
        case 5:
            alarm = EKAlarm(relativeOffset: 60 * 60 * 24)
        case 6:
            alarm = nil
        default:
            break
        }
        return alarm
    }
    /// 增
    open func createReminder(_ title: String, startDate: Date, endDate: Date, repeatIndex: NSInteger, remindIndexs: [Int], notes: String) {
        //创建一个新提醒
        let reminder = EKReminder(eventStore: eventStore)
        //添加日历
        reminder.calendar = ggCalendar()
        configReminder(reminder, title: title, startDate: startDate, endDate: endDate, repeatIndex: repeatIndex, remindIndexs: remindIndexs, notes: notes) { (flag, error) in
        }
    }
    
    open func configReminder(_ reminder: EKReminder, title: String?, startDate: Date, endDate: Date?, repeatIndex: NSInteger?, remindIndexs: [Int]?, notes: String?, priority: Int = 1, result: (Bool, Error?) -> Void) {
        
        if let t = title {
            reminder.title = t
        }
        
        var cal = NSCalendar.current
        cal.timeZone = NSTimeZone.system
        
        let flags: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        
        var sDateComp = cal.dateComponents(flags, from: startDate)
        sDateComp.timeZone = NSTimeZone.system
        //开始时间
        reminder.startDateComponents = sDateComp
        
        if let eDate = endDate {
            var eDateComp = cal.dateComponents(flags, from: eDate)
            eDateComp.timeZone = NSTimeZone.system
        }
        
        //到期时间
        reminder.dueDateComponents = sDateComp
        
        if let rIndex = repeatIndex {
            //重复规则
            if let rule = repeatRule(rIndex, currentDate: startDate) {
                reminder.recurrenceRules = [rule]
            } else {
                reminder.recurrenceRules = nil
            }
        }
        
        if let rIndexs = remindIndexs {
            //设置提醒
            var alarms: [EKAlarm] = []
            for i in rIndexs {
                if let alarm = alarmSetting(i) {
                    //                reminder.addAlarm(alarm)
                    alarms.append(alarm)
                }
            }
            reminder.alarms = alarms
        }
        
        //备注
        reminder.notes = notes
        //优先级
        reminder.priority = priority
        
        do {
            try eventStore.save(reminder, commit: true)
            print("提醒添加成功 ---  success ---")
            result(true, nil)
        } catch (let error) {
            print("提醒添加失败 ---  error --- \(error)")
             result(false, error)
        }
    }
    /// 查
    open func queryReminder(_ completion: @escaping (([EKReminder]?) -> Void)) {

        let calendar = NSCalendar.current
        let oneDayAgoComponents = NSDateComponents()
        oneDayAgoComponents.day = -1
        let oneDayAgo = calendar.date(byAdding: oneDayAgoComponents as DateComponents, to: Date())
        let oneMonthFromNowComponents = NSDateComponents()
        oneMonthFromNowComponents.month = 1
        let oneMonthFromNow = calendar.date(byAdding: oneMonthFromNowComponents as DateComponents, to: Date())
        
        if let cal = ggCalendar() {
            let predicate = eventStore.predicateForIncompleteReminders(withDueDateStarting: oneDayAgo, ending: oneMonthFromNow, calendars: [cal])
            eventStore.fetchReminders(matching: predicate) { (reminders) in
                completion(reminders)
                
                guard let result = reminders else {
                    print(" --- 没有查询到提醒内容 --- ")
                    return }
                for item in result {
                    print("query reminders --- \(item)")
                }
                
            }
        }
        
    }
    
    /// 改
    open func updateReminder(_ calendarItemIdentifier: String) {
        queryReminder({ [weak self] (reminders) in
            guard let `self` = self else { return }
            if let items = reminders {
                for item in items {
                    if item.calendarItemIdentifier == calendarItemIdentifier {
                        self.configReminder(item, title: "更新后的reminder", startDate: Date(timeInterval: 60 * 60, since: Date()), endDate: nil, repeatIndex: nil, remindIndexs: nil, notes: "更新后的 reminder note") { (flag, error) in
                        }
                    }
                }
            }
        })
    }
    
    /// 删
    open func removeReminder(_ calendarItemIdentifier: String) {
        queryReminder({ [weak self] (reminders) in
            guard let `self` = self else { return }
            if let items = reminders {
                for item in items {
                    if item.calendarItemIdentifier == calendarItemIdentifier {
                        do {
                            try self.eventStore.remove(item, commit: true)
                            print("删除 成功 --- success ---")
                        } catch (let error) {
                            print("删除 提醒失败 --- error --- \(error)")
                        }
                    }
                }
            }
        })
    }
    
    /// 权限申请
    open func requestAuthorized(_ type: EKEntityType, completion: @escaping ((Bool, NSError?) -> Void)) {
        let eventStatus = EKEventStore.authorizationStatus(for: type)
        if eventStatus == .authorized {
            completion(true, nil)
        } else if eventStatus == .notDetermined {
            eventStore.requestAccess(to: type) { (granted, error) in
                completion(granted, error as NSError?)
            }
        } else {
            let error = NSError(domain: NSCocoaErrorDomain, code: NSUserCancelledError, userInfo: [NSLocalizedDescriptionKey: "未授权"])
            completion(false, error)
        }
    }
    
}
