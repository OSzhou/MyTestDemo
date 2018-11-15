//
//  !coding.h
//  15_interviewQ
//
//  Created by Windy on 2018/3/13.
//  Copyright © 2018年 Windy. All rights reserved.
//

#ifndef _coding_h
#define _coding_h
//1、改变view的frame，layer的frame是否会变化？改变layer.frame，view的frame是否会变化？请问原因是什么？
//    ①:会
//    ②:会
//    ③:原因：一个 Layer 的 frame 是由它的 anchorPoint,position,bounds,和 transform 共同决定的，而一个 View 的 frame 只是简单的返回 Layer的 frame，同样 View 的 center和 bounds 也是返回 Layer 的一些属性。它俩之间的frame是映射的关系，所以一个变另一个也跟着变。
//2、 autoreleasepool的释放时机是什么，什么时候需要自己声明一个autoreleasepool。
//    ①:每个线程创建的时候就会创建一个autorelease pool，并且在线程退出的时候（runloop迭代结束时），清空autorelease pool：CFRunLoopObserver 监视到kCFRunLoopBeforeWaiting(将要进入休眠) 时调用_objc_autoreleasePoolPop() 和 _objc_autoreleasePoolPush() 释放旧的池并创建新池；kCFRunLoopExit(即将退出Loop) 时会调用 _objc_autoreleasePoolPop() 来释放自动释放池。
//    ②:1.如果你编写的程序不是基于 UI 框架的，比如说命令行工具；
//       2.如果你编写的循环中创建了大量的临时对象；
//       3.如果你创建了一个辅助线程。
//
//3、 nsdictionry底层的数据结构是什么，根据key找到value的时间复杂度是多少？
//    ①:NSDictionary（字典）是使用 hash表来实现key和value之间的映射和存储的， hash函数设计的好坏影响着数据的查找访问效率。
//    ②:时间复杂度：O(1);
//
//4、 求一个整数数组中和最大的连续子数组，例如：[1, 2, -4, 4, 10, -3, 4, -5, 1]的最大连续子数组是[4, 10, -3, 4]（需写明思路，并编程实现）。
//    ①:思路：基于Kadane算法，从传入数组的第一项开始向后累加，比较累加和，当前和大于之前和时，更新子数组开始下标和结束下标，当和为负值时丢弃，从下一个索引开始重新累加，直到数组最后一项。
//    ②:编程实现
///* - (NSArray *)maxSubArrayIn:(NSArray *) array {
//      maxSumSoFar给最小值，因为数组内可能有负数
//     int maxSumSoFar = -INT_MIN;
//      curSum: 记录当前和，maxSum：记录最大和
//     int curSum = 0, maxSum;
//      a:当前最大子数组开始下标 b:当前最大子数组结束下标 s:开始的下标
//     int a = 0, b = 0, s = 0, i = 0;
//     for( i = 0; i < array.count; i++ ) {
//         当前最大和 + 当前下标的值
//         curSum += (int)array[i];
//         if ( curSum > maxSumSoFar ) {
//             maxSumSoFar = curSum;
//             s 是子数组开始下标
//             a = s;
//             b 是子数组结束下标
//             b = i;
//         }
//         如果curSum小于0， 需要重设curSum的值和开始下标
//         if( curSum < 0 ) {
//             curSum = 0;
//             s = i + 1;
//         }
//    }
//      根据最终的a, b值截取和最大的连续子数组
//     NSArray * subArr = [array subarrayWithRange:NSMakeRange(a, b - a + 1)];
//     maxSum = maxSumSoFar;
//     return subArr;
// }*/
//
//5、 请简述在iOS项目中遇到的最大的技术问题是什么，如何解决的？
//    ①:多库共存冲突问题。解决办法：动态库
//    ②:处理超出父控件的子控件接收的事件。解决办法：重写父控件的- (UIView *)hitTest: withEvent:方法
//选做题（可四选一）：
//1、 请实现一个完善内存的图片缓存工具，key为url，value为uimage。缓存最大可容纳100张图片，并有淘汰机制。（需编程实现）
///*
//    typedef void (^FMCallBlock)(UIImage *);
//     内存缓存的图片
//    @property (nonatomic, strong) NSMutableDictionary *images;
//     队列对象
//    @property (nonatomic, strong) NSOperationQueue *queue;
// 
// - (NSOperationQueue *)queue {
//     if (!_queue) {
//         _queue = [[NSOperationQueue alloc] init];
//         _queue.maxConcurrentOperationCount = 3;
//     }
//     return _queue;
// }
// 
// - (NSMutableDictionary *)images {
//     if (!_images) {
//         _images = [NSMutableDictionary dictionary];
//     }
//     return _images;
// }
// 
// - (void)downloadImageByURL:(NSString *)url image:(FMCallBlock) callback {
//      先从内存缓存中取出图片
//     UIImage *image;
//     if (image) {  内存中有图片
//         !callback?:callback(self.images[url]);
//     } else{  下载图片
//         [self.queue addOperationWithBlock:^{
//              下载图片
//             NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
//             UIImage *image = [UIImage imageWithData:data];
// 
//              请求完成返回
//             !callback?:callback(image);
// 
//              存到字典中
//             if (_images.count>100) {
//                 [_images removeObjectForKey:[[_images allKeys] firstObject]];
//             }
//             self.images[url] = image;
//         }];
//     }
// }
// */
//2、 请用效率最高的方式绘制不同颜色的10w个的三角形（需编程实现）
///*
// - (CAShapeLayer *)createLayerWith:(UIColor *)color {
//      线的路径
//     UIBezierPath *polygonPath = [UIBezierPath bezierPath];
//      这些点的位置都是相对于所在视图的
//      起点
//     [polygonPath moveToPoint:CGPointMake(20, 40)];
//      其他点
//     [polygonPath addLineToPoint:CGPointMake(160, 160)];
//     [polygonPath addLineToPoint:CGPointMake(140, 50)];
//     [polygonPath closePath];  添加一个结尾点和起点相同
// 
//     CAShapeLayer *polygonLayer = [CAShapeLayer layer];
//     polygonLayer.lineWidth = 2;
//     polygonLayer.strokeColor = [UIColor greenColor].CGColor;
//     polygonLayer.path = polygonPath.CGPath;
//     polygonLayer.fillColor = color.CGColor;  默认为blackColor
//     return polygonLayer;
// }
// 
// */
//3、 请用完善的代码实现异步并发读写文件的接口函数（需编程实现）
///*
// typedef void (^FMFileContentBlock)(NSData *);
// 
// - (void)asyncConcurrentWith:(NSArray *)fileNames content:(FMFileContentBlock)contentBlock {
//  1.获得全局的并发队列
// dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
// 
//  2.将任务加入队列
// NSLock *lock = [[NSLock alloc] init];
//  获得Library/Caches文件夹
// NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
//     for (int i = 0; i < fileNames.count; i++) {
//         dispatch_async(queue, ^{
//             [lock lock];
//              获得文件名
//             NSString *filename = fileNames[i];
//              计算出文件的全路径
//             NSString *file = [cachesPath stringByAppendingPathComponent:filename];
//              加载沙盒的文件数据
//             NSData *data = [NSData dataWithContentsOfFile:file];
//             !contentBlock?:contentBlock(data);
//             [lock unlock];
//         });
//     }
// }
// */
#endif /* _coding_h */
