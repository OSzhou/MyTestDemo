//
//  FMSemaphoreDemo.swift
//  GCD_Test
//
//  Created by Zhouheng on 2020/8/7.
//  Copyright © 2020 tataUFO. All rights reserved.
//

import UIKit

class FMSemaphoreDemo: FMBaseDemo {
    
    let semaphore = DispatchSemaphore(value: 5)
    let moneySemaphore = DispatchSemaphore(value: 1)
    let ticketSemaphore = DispatchSemaphore(value: 1)
    
    override func __drawMoney() {
        moneySemaphore.wait()
        super.__drawMoney()
        moneySemaphore.signal()
    }
    
    override func __saveMoney() {
        moneySemaphore.wait()
        super.__saveMoney()
        moneySemaphore.signal()
    }
    
    override func __saleTicket() {
        ticketSemaphore.wait()
        super.__saleTicket()
        ticketSemaphore.signal()
    }
    
    override func otherTest() {
        for _ in 0..<20 {
            Thread(target: self, selector: #selector(test), object: nil).start()
        }
    }
    
    @objc func test() {
        semaphore.wait()
        Thread.sleep(forTimeInterval: 2.0)
        print(" --- test \(Thread.current) ---")
        semaphore.signal()
    }
}
