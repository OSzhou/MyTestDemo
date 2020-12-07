//
//  FMMutexDemo.swift
//  GCD_Test
//
//  Created by Zhouheng on 2020/8/7.
//  Copyright © 2020 tataUFO. All rights reserved.
//

import UIKit

class FMMutexDemo: FMBaseDemo {
    
    var moneyMutex = pthread_mutex_t()
    var ticketMutex = pthread_mutex_t()
    
    var mutex = pthread_mutex_t()
    var cond = pthread_cond_t()
    var data = [String]()
    
    override init() {
        super.init()
//        self.configMutex(&moneyMutex)
//        self.configMutex(&ticketMutex)
//
//        self.config2Mutex(&mutex)
        self.config3Mutex(&mutex)
        
    }
    
    func configMutex(_ mutex: inout pthread_mutex_t) {
        pthread_mutex_init(&mutex, nil)
    }
    
    func config2Mutex(_ mutex: inout pthread_mutex_t) {
        // 递归锁：允许同一个线程对一把锁进行重复加锁
        
        // 初始化属性
        var arr = pthread_mutexattr_t()
        pthread_mutexattr_init(&arr)
        pthread_mutexattr_settype(&arr, PTHREAD_MUTEX_RECURSIVE)
        // 初始化锁
        pthread_mutex_init(&mutex, &arr)
        // 销毁属性
        pthread_mutexattr_destroy(&arr)
    }
    
    func config3Mutex(_ mutex: inout pthread_mutex_t) {
        // 递归锁：允许同一个线程对一把锁进行重复加锁
        
        // 初始化属性
        var arr = pthread_mutexattr_t()
        pthread_mutexattr_init(&arr)
        pthread_mutexattr_settype(&arr, PTHREAD_MUTEX_RECURSIVE)
        // 初始化锁
        pthread_mutex_init(&mutex, &arr)
        // 销毁属性
        pthread_mutexattr_destroy(&arr)
        
        // 初始化条件
        pthread_cond_init(&cond, nil)
    }
    
    override func __saleTicket() {
        
        pthread_mutex_lock(&ticketMutex)
        super.__saleTicket()
        pthread_mutex_unlock(&ticketMutex)
        
    }
    
    override func __saveMoney() {
        pthread_mutex_lock(&moneyMutex)
        super.__saveMoney()
        pthread_mutex_unlock(&moneyMutex)
    }
    
    override func __drawMoney() {
        pthread_mutex_lock(&moneyMutex)
        super.__drawMoney()
        pthread_mutex_unlock(&moneyMutex)
    }
    
    override func otherTest() {
//        config2Test()
        config3Test()
    }
    
    var count = 0
    func config2Test() {
        pthread_mutex_lock(&mutex)
        
        print(" --- \(#function) --- ")
        if count < 10 {
            count += 1
            self.otherTest()
        }
        
        pthread_mutex_unlock(&mutex)
    }
    
    func config3Test() {
        Thread(target: self, selector: #selector(__remove), object: nil).start()
        Thread(target: self, selector: #selector(__add), object: nil).start()
    }
    
    // 生产者-消费者模式

    // 线程1
    // 删除数组中的元素
    @objc func __remove() {
        pthread_mutex_lock(&mutex)
        
        print(" --- remove - begin --- ")
        if data.isEmpty {
            // 等待 睡眠后会放开这把锁
            pthread_cond_wait(&cond, &mutex)
            //满足条件唤醒后重新加锁
        }
        
        if !data.isEmpty {
            data.removeLast()
            print(" --- 删除了元素 ---")
        }
        
        pthread_mutex_unlock(&mutex)
    }
    
    // 线程2
    // 往数组中添加元素
    @objc func __add() {
        pthread_mutex_lock(&mutex)
         
         Thread.sleep(forTimeInterval: 1)
         data.append("Test")
         print(" --- 添加了元素--- ")
        
         // 信号 （唤醒一个）
             pthread_cond_signal(&cond);
             // 广播 （唤醒所有等待线程）
         //    pthread_cond_broadcast(&cond);
         
         pthread_mutex_unlock(&mutex)
    }
    
    
    
    deinit {
        pthread_mutex_destroy(&moneyMutex)
        pthread_mutex_destroy(&ticketMutex)
        pthread_mutex_destroy(&mutex)
        pthread_cond_destroy(&cond)
    }
}
