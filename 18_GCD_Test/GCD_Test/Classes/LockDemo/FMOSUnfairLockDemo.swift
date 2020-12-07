//
//  FMOSUnfairLockDemo.swift
//  GCD_Test
//
//  Created by Zhouheng on 2020/8/7.
//  Copyright © 2020 tataUFO. All rights reserved.
//

import UIKit
import libkern

class FMOSUnfairLockDemo: FMBaseDemo {
    var testLock = NSLock()
    var moneyLock = os_unfair_lock(_os_unfair_lock_opaque: UInt32(OS_SPINLOCK_INIT))
    var ticketLock = os_unfair_lock(_os_unfair_lock_opaque: UInt32(OS_SPINLOCK_INIT))
    
    override func otherTest() {
        
        // 一个线程枷锁另一个线程解锁（是可以的）
        let thread = Thread {
            RunLoop.current.add(Port(), forMode: .default)
            RunLoop.current.run(mode: .default, before: .distantFuture)
        }
        thread.start()
        self.perform(#selector(__add), on: thread, with: nil, waitUntilDone: true)
        
        let thread1 = Thread {
            RunLoop.current.add(Port(), forMode: .default)
            RunLoop.current.run(mode: .default, before: .distantFuture)
        }
        thread1.start()
        self.perform(#selector(__remove), on: thread1, with: nil, waitUntilDone: true)
        
    }
    
    override func __saveMoney() {
        os_unfair_lock_lock(&moneyLock)
//        testLock.lock()
        super.__saveMoney()
        print(" --- saveMoney ---")
    }
    
    @objc func __remove() {
        print("thread --- \(Thread.current)")
        Thread.sleep(forTimeInterval: 1)
        os_unfair_lock_unlock(&moneyLock)
//        testLock.unlock()
//        Thread(target: self, selector: #selector(__add), object: nil).start()
        let thread = Thread {
            RunLoop.current.add(Port(), forMode: .default)
            RunLoop.current.run(mode: .default, before: .distantFuture)
        }
        thread.start()
        self.perform(#selector(__add), on: thread, with: nil, waitUntilDone: false)
    }
        
    @objc func __add() {
        
        self.__saveMoney()
        
    }
    
    override func __drawMoney() {
//        os_unfair_lock_lock(&moneyLock)
        super.__drawMoney()
//        os_unfair_lock_unlock(&moneyLock)
    }
    
    override func __saleTicket() {
        os_unfair_lock_lock(&ticketLock)
        super.__saleTicket()
        os_unfair_lock_unlock(&ticketLock)
    }
}
