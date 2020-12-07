//
//  FMLockDemo.swift
//  GCD_Test
//
//  Created by Zhouheng on 2020/8/6.
//  Copyright © 2020 tataUFO. All rights reserved.
//

import UIKit

class FMLockDemo: FMBaseDemo {
    let moneyLock = NSLock()
    let ticketLock = NSLock()
    
    override func __saveMoney() {
        moneyLock.lock()
        super.__saveMoney()
        moneyLock.unlock()
    }
    
    override func __drawMoney() {
        moneyLock.lock()
        super.__drawMoney()
        moneyLock.unlock()
    }
    
    override func __saleTicket() {
        ticketLock.lock()
        super.__saleTicket()
        ticketLock.unlock()
    }
}
