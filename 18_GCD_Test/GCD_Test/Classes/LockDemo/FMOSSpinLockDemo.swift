//
//  FMOSSpinLockDemo.swift
//  GCD_Test
//
//  Created by Zhouheng on 2020/8/6.
//  Copyright © 2020 tataUFO. All rights reserved.
//

import UIKit
import libkern

class FMOSSpinLockDemo: FMBaseDemo {
    
    let moneyLock = UnsafeMutablePointer<OSSpinLock>.allocate(capacity: 0)
    let ticketLock = UnsafeMutablePointer<OSSpinLock>.allocate(capacity: 0)
    
    override func __saveMoney() {
//        let lock = UnsafeMutablePointer<OSSpinLock>.allocate(capacity: 0)
        OSSpinLockLock(moneyLock)
        super.__saveMoney()
        OSSpinLockUnlock(moneyLock)
    }
    
    override func __drawMoney() {
        OSSpinLockLock(moneyLock)
        super.__drawMoney()
        OSSpinLockUnlock(moneyLock)
    }
    
    override func __saleTicket() {
        OSSpinLockLock(ticketLock)
        super.__saleTicket()
        OSSpinLockLock(ticketLock)
    }
}

