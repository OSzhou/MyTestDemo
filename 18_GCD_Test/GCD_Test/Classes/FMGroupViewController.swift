//
//  FMGroupViewController.swift
//  GCD_Test
//
//  Created by Zhouheng on 2020/8/6.
//  Copyright © 2020 tataUFO. All rights reserved.
//

import UIKit

class FMGroupViewController: UIViewController {

    var baseDemo = FMBaseDemo()
    var lockDemo = FMLockDemo()
    var semaphoreDemo = FMSemaphoreDemo()
    var unfairLockDemo = FMOSUnfairLockDemo()
    var mutexDemo = FMMutexDemo()
    var serialDemo = FMSerialQueueDemo()
    var synchronizeDemo = FMSynchronizeDemo()
    var conditionDemo = FMConditionDemo()
    var conditionLockDemo = FMConditionLockDemo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        // Do any additional setup after loading the view.
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
//        lockDemo.moneyTest()
//        semaphoreDemo.otherTest()
//        semaphoreDemo.moneyTest()
//        unfairLockDemo.moneyTest()
        
//        mutexDemo.moneyTest()
//        mutexDemo.otherTest()
        
//        serialDemo.moneyTest()
        
//        synchronizeDemo.moneyTest()
        
        conditionDemo.otherTest()
//        conditionLockDemo.otherTest()
        
        
//        unfairLockDemo.otherTest()
        
        return
        
        let group = DispatchGroup()
        let mqueue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)
        
        for _ in 0..<5 {
            let item = DispatchWorkItem {
                print("task 111 --- \(Thread.current)")
            }
            mqueue.async(group: group, execute: item)
        }

        for _ in 0..<5 {
            let item = DispatchWorkItem {
                print("task 222 --- \(Thread.current)")
            }
            mqueue.async(group: group, execute: item)
        }
        
        /// --- notify ---
        
//        group.notify(queue: queue) {
//            for _ in 0..<5 {
//                print("task 555 --- \(Thread.current)")
//            }
//        }
        
        /// 任务5 和 任务3是按顺序执行吗
        /// 任务5 和 任务3实在同一线程执行的吗
        /// 任务5 和 任务3所在线程是新创建的吗
        
        group.notify(queue: mqueue) {
            print("555 - out --- \(Thread.current)")
            mqueue.sync {
                for _ in 0..<5 {
                    print("task 555 --- \(Thread.current)")
                }
            }
        }

        group.notify(queue: mqueue) {
            print("333 - out --- \(Thread.current)")
            mqueue.sync {
                for _ in 0..<5 {
                    print("task 333 --- \(Thread.current)")
                }
            }
        }
        
//        group.notify(queue: queue) {
//            print("out --- \(Thread.current)")
//            DispatchQueue.main.async {
//                for _ in 0..<5 {
//                    print("task 333 --- \(Thread.current)")
//                }
//            }
//        }
//
//        group.notify(queue: DispatchQueue.main) {
//            for _ in 0..<5 {
//                print("task 444 --- \(Thread.current)")
//            }
//        }
//        group.notify(queue: DispatchQueue.main) {
//            print("out --- \(Thread.current)")
//            mqueue.async {
//                for _ in 0..<5 {
//                    print("task 444 --- \(Thread.current)")
//                }
//            }
//
//            mqueue.async {
//                for _ in 0..<5 {
//                    print("task 666 --- \(Thread.current)")
//                }
//            }
//
//            mqueue.async {
//                for _ in 0..<5 {
//                    print("task 777 --- \(Thread.current)")
//                }
//            }
//        }
    }

}
