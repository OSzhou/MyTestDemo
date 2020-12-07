//
//  FMQuestionsViewController.swift
//  GCD_Test
//
//  Created by Zhouheng on 2020/8/5.
//  Copyright © 2020 tataUFO. All rights reserved.
//

import UIKit

class FMQuestionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
//        question1()
//        question2()
        question3()
//        question4()
//        question5()
//        question6()
    }
    
    // 问题：以下代码是在主线程执行的，会不会产生死锁？
    func question1() {
        print("\(#function) --- task 1 --- ")
        let queue = DispatchQueue.main
        queue.sync {// sync立马在当前线程同步执行任务
            print("\(#function) --- task 2 --- ")
        }
        print("\(#function) --- task 3 --- ")
    }
    
    // 问题：以下代码是在主线程执行的，会不会产生死锁？
    func question2() {
        print("\(#function) --- task 1 --- ")
        let queue = DispatchQueue.main
        queue.async {// async不要求立马在当前线程同步执行任务
            print("\(#function) --- task 2 --- ")
        }
        print("\(#function) --- task 3 --- ")
    }
    
    // 问题：以下代码执行，会不会产生死锁？
    func question3() {
        print("\(#function) --- task 1 --- ")
        let queue = DispatchQueue(label: "test")
        queue.sync {
            print("\(#function) --- task 2 --- ")
            
//            queue.sync {
//                print("\(#function) --- task 4 --- ")
//            }
            
        }
        print("\(#function) --- task 3 --- ")
    }
        
    // 问题：以下代码是在主线程执行的，会不会产生死锁？
    func question4() {
        print("\(#function) --- task 1 --- ")
        let queue = DispatchQueue(label: "serialQueue")
        queue.async {
            print("\(#function) --- task 2 --- ")
            queue.sync {
                print("\(#function) --- task 3 --- ")
            }
            print("\(#function) --- task 4 --- ")
        }
        print("\(#function) --- task 5 --- ")
    }
    
    // 问题：以下代码是在主线程执行的，会不会产生死锁？
    func question5() {
        print("\(#function) --- task 1 --- ")
        let queue = DispatchQueue(label: "serialQueue")
        let queue2 = DispatchQueue(label: "serialQueue2")
        queue.async {
            print("\(#function) --- task 2 --- ")
            queue2.sync {
                print("\(#function) --- task 3 --- ")
            }
            print("\(#function) --- task 4 --- ")
        }
        print("\(#function) --- task 5 --- ")
    }
    
    // 问题：以下代码是在主线程执行的，会不会产生死锁？
    func question6() {
        print("\(#function) --- task 1 --- ")
        let queue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)
        queue.async {
            print("\(#function) --- task 2 --- ")
            queue.sync {
                print("\(#function) --- task 3 --- ")
            }
            print("\(#function) --- task 4 --- ")
        }
        print("\(#function) --- task 5 --- ")
    }
}
