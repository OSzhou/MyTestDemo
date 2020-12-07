//
//  FMConditionDemo.swift
//  GCD_Test
//
//  Created by Smile on 2020/8/9.
//  Copyright © 2020 tataUFO. All rights reserved.
//

import UIKit

class FMConditionDemo: FMBaseDemo {
    var data = [String]()
    var condition = NSCondition()
    
    override func otherTest() {
        Thread(target: self, selector: #selector(__remove), object: nil).start()
        Thread(target: self, selector: #selector(__add), object: nil).start()
    }
    
    // 生产者-消费者模式

    // 线程1
    // 删除数组中的元素
   @objc func __remove() {
        condition.lock()
        print(" --- remove - begin --- ")
        if data.isEmpty {
            // 等待 睡眠后会放开这把锁
            condition.wait()
            //满足条件唤醒后重新加锁
        }
        
        if !data.isEmpty {
            data.removeLast()
            print(" --- 删除了元素 ---")
        }
        condition.unlock()
    }
    
    // 线程2
    // 往数组中添加元素
    @objc func __add() {
        condition.lock()
        Thread.sleep(forTimeInterval: 1)
         data.append("Test")
         print(" --- 添加了元素--- ")
        
         // 信号 （唤醒一个）
        condition.signal()
             // 广播 （唤醒所有等待线程）
//        condition.broadcast()
        condition.unlock()
    }
    
}
