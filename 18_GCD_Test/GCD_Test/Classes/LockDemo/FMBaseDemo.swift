//
//  FMBaseDemo.swift
//  GCD_Test
//
//  Created by Zhouheng on 2020/8/6.
//  Copyright © 2020 tataUFO. All rights reserved.
//

import UIKit

class FMBaseDemo: NSObject {
    
    var money: Int = 0
    var ticketsCount = 0
    
    func otherTest() {}
    
    /// 存钱 取钱
    func moneyTest() {
        money = 100
        let queue = DispatchQueue.global()
        queue.async {
            for _ in 0..<10 {
                self.__saveMoney()
            }
        }
        queue.async {
            for _ in 0..<10 {
                self.__drawMoney()
            }
        }
    }
    
    /// 存钱
    func __saveMoney() {
        var oldMoney = money
        Thread.sleep(forTimeInterval: 0.3)
        oldMoney += 50
        money = oldMoney
        print("存50，还剩\(oldMoney)元，--- \(Thread.current)")
    }
    
    /// 取钱
    func __drawMoney() {
        var oldMoney = money
        Thread.sleep(forTimeInterval: 0.3)
        oldMoney -= 20
        money = oldMoney
        print("取20，还剩\(oldMoney)元，--- \(Thread.current)")
    }
    
    /// 卖一张票
    func __saleTicket() {
        var oldTicketCount = ticketsCount
        Thread.sleep(forTimeInterval: 0.2)
        oldTicketCount -= 1
        ticketsCount = oldTicketCount
        print("还剩\(oldTicketCount)张票 --- \(Thread.current)")
    }
    
    /// 买票演示
    func ticketTest() {
        ticketsCount = 15
        let queue = DispatchQueue.global()
        queue.async {
            for _ in 0..<5 {
                self.__saleTicket()
            }
        }
        
        queue.async {
            for _ in 0..<5 {
                self.__saleTicket()
            }
        }
        
        queue.async {
            for _ in 0..<5 {
                self.__saleTicket()
            }
        }
    }
}
