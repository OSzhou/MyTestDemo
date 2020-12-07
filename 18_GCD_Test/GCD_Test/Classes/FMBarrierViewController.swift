//
//  FMBarrierViewController.swift
//  GCD_Test
//
//  Created by Zhouheng on 2020/8/6.
//  Copyright © 2020 tataUFO. All rights reserved.
//

import UIKit

class FMBarrierViewController: UIViewController {
    // 因为上一句已经添加了一个timer，所以这句可以省略
    // 如果传入的是一个串行或是一个全局的并发队列，那这个函数便等同于dispatch_async函数的效果
    let queue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)
    
    var lock = pthread_rwlock_t()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
        // Do any additional setup after loading the view.
    }
    
    func configPthread_rwlock() {
        pthread_rwlock_init(&lock, nil)
        for _ in 0..<10 {
            queue.async {
                self.read3()
            }
            queue.async {
                self.write3()
            }
        }
    }
    
    func read3() {
        pthread_rwlock_rdlock(&lock)
        
        Thread.sleep(forTimeInterval: 1)
        print(" --- read3 ---")
        
        pthread_rwlock_unlock(&lock)
    }
    
    func write3() {
        pthread_rwlock_wrlock(&lock)
        
        Thread.sleep(forTimeInterval: 1)
        print(" --- write3 ---")
        
        pthread_rwlock_unlock(&lock)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        test()
//        test2()
    }

    
    
    func test2() {
        for _ in 0..<10 {
            
            self.read2()
            self.read2()
            self.read2()
            self.write2()
            
        }
    }
    
    func read2() {
        queue.async {
            Thread.sleep(forTimeInterval: 1)
            print(" --- read2 --- ")
        }
    }
    
    func write2() {
        queue.async(flags: .barrier) {
            Thread.sleep(forTimeInterval: 1)
            print(" --- write2 --- ")
        }
    }
        
    func test() {
        for _ in 0..<10 {
            queue.async {
                self.read()
            }
            
            queue.async {
                self.read()
            }
            
            queue.async {
                self.read()
            }
            
            queue.async(flags: .barrier) {
                self.write()
            }
        }
    }
    
    func read() {
        Thread.sleep(forTimeInterval: 1)
        print(" --- read --- ")
    }
    
    func write() {
        Thread.sleep(forTimeInterval: 3)
        print(" --- write --- ")
    }
    
    deinit {
        pthread_rwlock_destroy(&lock)
    }
}
