//
//  UIButton+Extension.m
//  RunTime_Test
//
//  Created by HIALLiOS on 16/3/4.
//  Copyright © 2016年 HIALLiOS. All rights reserved.
//

#import "UIButton+Extension.h"
#import <objc/runtime.h>

@interface UIButton ()

@property (nonatomic, assign) NSTimeInterval cjr_acceptEventTime;

@end

@implementation UIButton (Extension)

static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";
static const char *UIControl_acceptEventTime = "UIControl_acceptEventTime";

//objc_setAssociatedObject,objc_getAssociatedObject关联(set get 方法)。
- (void)setCjr_acceptEventInterval:(NSTimeInterval)cjr_acceptEventInterval{
    //四个参数：源对象，关键字，关联的对象和一个关联策略
    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(cjr_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval )cjr_acceptEventInterval{
    return [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}

- (void)setCjr_acceptEventTime:(NSTimeInterval)cjr_acceptEventTime{
    objc_setAssociatedObject(self, UIControl_acceptEventTime, @(cjr_acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval )cjr_acceptEventTime{
    return [objc_getAssociatedObject(self, UIControl_acceptEventTime) doubleValue];
}

+ (void)load{
    //获取着两个方法
    //系统方法
    Method systemMethod = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    SEL sysSEL = @selector(sendAction:to:forEvent:);
    //自定义方法
    Method myMethod = class_getInstanceMethod(self, @selector(cjr_sendAction:to:forEvent:));
    SEL mySEL = @selector(cjr_sendAction:to:forEvent:);
    
    //这样也可以（但是注意顺序）
    
    /******
     *
     *个人理解：
     *不管是add还是replace和系统重名的方法，都是相当于复制了一个和系统重名的函数（也就是
     *相当于继承重写了父类方法 ps:分类中不支持继承！系统发现有这个方法会优先调用）
     *系统自动复制一个与自己同名的方法给开发人员用，但是method_getImplementation(systemMethod)
     *还是获取系统自带方法的属性
     *
     ******/
    
//    class_replaceMethod(self, sysSEL, method_getImplementation(myMethod), method_getTypeEncoding(myMethod));//系统自动复制一份
//    class_replaceMethod(self, mySEL, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
 
    
    //添加方法进去（系统方法名执行自己的自定义函数，相当于重写父类方法）
    BOOL didAddMethod = class_addMethod(self, sysSEL, method_getImplementation(myMethod), method_getTypeEncoding(myMethod));//系统自动复制一个份
    
    //如果添加成功
    if (didAddMethod) {
        //自定义函数名执行系统函数
        class_replaceMethod(self, mySEL, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
    }else{
        method_exchangeImplementations(systemMethod, myMethod);
        
    }
    //----------------以上主要是实现两个方法的互换,load是gcd的只shareinstance，果断保证执行一次
}

- (void)cjr_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    if (NSDate.date.timeIntervalSince1970 - self.cjr_acceptEventTime < self.cjr_acceptEventInterval) {
        return;
    }
    
    if (self.cjr_acceptEventInterval > 0) {
        self.cjr_acceptEventTime = NSDate.date.timeIntervalSince1970;//记录上次点击的时间
    }
    
    [self cjr_sendAction:action to:target forEvent:event];//这里并不是循环调用，由于交换了两个方法，cjr_sendAction:to:forEvent:现在就是sendAction:to:forEvent:
}

/** 汉字URL转换 */
/*
 - (NSString *)URLEncodedString
 {
 NSString *encodedString = (NSString *)
 CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
 (CFStringRef)self,
 (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
 NULL,
 kCFStringEncodingUTF8);
 return encodedString;
 }
 */

@end
