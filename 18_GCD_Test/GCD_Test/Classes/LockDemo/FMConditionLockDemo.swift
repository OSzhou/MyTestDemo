//
//  FMConditionLockDemo.swift
//  GCD_Test
//
//  Created by Zhouheng on 2020/8/7.
//  Copyright © 2020 tataUFO. All rights reserved.
//

import UIKit

class FMConditionLockDemo: FMBaseDemo {

    var conditionLock = NSConditionLock(condition: 1)
    
    override func otherTest() {
        Thread(target: self, selector: #selector(__one), object: nil).start()
        Thread(target: self, selector: #selector(__two), object: nil).start()
        Thread(target: self, selector: #selector(__three), object: nil).start()
    }
    
    @objc func __one() {
        // 忽视条件加锁
        conditionLock.lock()
        // 根据条件加锁
//        conditionLock.lock(whenCondition: 1)
        print(" --- one ---")
        Thread.sleep(forTimeInterval: 2)
        // 解锁后并把condition置为2
        conditionLock.unlock(withCondition: 2)
    }
    
    @objc func __two() {
        conditionLock.lock(whenCondition: 2)
        
        print(" --- two ---")
        Thread.sleep(forTimeInterval: 2)
        conditionLock.unlock(withCondition: 3)
    }
    
    @objc func __three() {
        conditionLock.lock(whenCondition: 3)
//        Thread.sleep(forTimeInterval: 3)
        print(" --- three ---")
        
        conditionLock.unlock()
    }
}
