//
//  FMSynchronizeDemo.swift
//  GCD_Test
//
//  Created by Zhouheng on 2020/8/7.
//  Copyright © 2020 tataUFO. All rights reserved.
//

import UIKit

class FMSynchronizeDemo: FMBaseDemo {

    override func __drawMoney() {
        objc_sync_enter(self)
        super.__drawMoney()
        objc_sync_exit(self)
    }
    
    override func __saveMoney() {
        objc_sync_enter(self)
        super.__saveMoney()
        objc_sync_exit(self)
    }
    
    override func __saleTicket() {
        objc_sync_enter(self)
        super.__saleTicket()
        objc_sync_exit(self)
    }
    
    override func otherTest() {
        objc_sync_enter(self)
        print(" --- synchronize OtherTest ---")
        self.otherTest()
        objc_sync_exit(self)
    }
    
}
