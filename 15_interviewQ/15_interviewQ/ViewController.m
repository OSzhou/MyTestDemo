//
//  ViewController.m
//  15_interviewQ
//
//  Created by Windy on 2018/3/13.
//  Copyright © 2018年 Windy. All rights reserved.
//

#import "ViewController.h"
#import "UIButton+TestBtn.h"

typedef void (^testBlock)(void);
@interface ViewController ()

@property (nonatomic, strong) UIView *v;
@property (nonatomic, strong) CALayer *l;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // layer 和 frame的关系测试
//    _v = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
//    _v.backgroundColor = [UIColor cyanColor];
//    _l = _v.layer;
//    [self.view addSubview:_v];
//    NSLog(@"v---%@ l---%@", NSStringFromCGRect(_v.frame),NSStringFromCGRect(_l.frame));
    // 最大子数组测试
//    NSArray * arr = @[@1, @2, @(-4), @4, @10, @(-3), @4, @(-5), @1];
//    NSArray * arr = @[@1, @2, @(-4), @4, @10, @(-3)];
//    NSArray * arr = @[@(-1), @(-2), @3];
//    NSArray * arr = @[@(-2), @(-1), @(-3)];
//    NSArray * arr = @[@0, @1, @2, @4, @10];
//    NSArray *maxSubArr = [self maxSubArrayIn:arr];
//    NSLog(@" --- %@", maxSubArr);
    // 十万个三角形
//    UIView * polygonView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) - 100, CGRectGetMidY(self.view.frame) - 100, 200, 200)];
//    polygonView.backgroundColor = [UIColor orangeColor];
//    [self.view addSubview:polygonView];
//    for (int i = 0; i < 100000; i++) {
//        [polygonView.layer addSublayer:[self createLayerWith:[UIColor colorWithRed:(arc4random() % 255/255.0) green:arc4random() % 255/255.0 blue:arc4random() % 255/255.0 alpha:1.0]]];
//    }
    NSLog(@"1111111111");
    [self arrCountTest];
    [self testBlock];
}

- (void)testBlock {
    // block 不会立即执行，要等到testBlock这个函数加载完再回来执行
    int a = 23;// 没用__block修饰，其之下的block中存储的值不会跟着改变
    __block int b = 23;// 用__block修饰，其之下的block中存储的值会跟着改变
    testBlock block1 = ^{
        NSLog(@"---%d", a);
    };
    testBlock block2 = ^{
        NSLog(@"---%d", b);
    };
    
    a = 32;// 这里由于没有__block修饰，所以修改只对其之下的block起作用
    b = 32;// 这里的有__block修饰，所以修改对全局有效
    
    testBlock block3 = ^{
        NSLog(@"---%d", a);
    };
    testBlock block4 = ^{
        NSLog(@"---%d", b);
    };
    block1();// 23
    block2();// 32
    block3();// 32
    block4();// 32
}

- (void)arrCountTest {
    NSArray *arr = @[@1, @2, @3];
    if ((arr.count - 1) > 1) {
        NSLog(@"可以执行！！！");
    }
}

- (CAShapeLayer *)createLayerWith:(UIColor *)color {
    // 线的路径
    UIBezierPath *polygonPath = [UIBezierPath bezierPath];
    // 这些点的位置都是相对于所在视图的
    // 起点
    [polygonPath moveToPoint:CGPointMake(20, 40)];
    // 其他点
    [polygonPath addLineToPoint:CGPointMake(160, 160)];
    [polygonPath addLineToPoint:CGPointMake(140, 50)];
    [polygonPath closePath]; // 添加一个结尾点和起点相同
    
    CAShapeLayer *polygonLayer = [CAShapeLayer layer];
    polygonLayer.lineWidth = 2;
    polygonLayer.strokeColor = [UIColor greenColor].CGColor;
    polygonLayer.path = polygonPath.CGPath;
    polygonLayer.fillColor = color.CGColor; // 默认为blackColor
    return polygonLayer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
int i = 0;
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    i += 50;
//    _v.frame = CGRectMake(10, 10, 50+i, 50+i);
    _l.frame = CGRectMake(10, 10, 50+i, 50+i);
    NSLog(@"v---%@ l---%@", NSStringFromCGRect(_v.frame),NSStringFromCGRect(_l.frame));
}

//void maxSumSubArray( Array array, int start, int end, int maxSum ){
//    // maxSumSoFar给最小值，因为数组内可能有负数
//    int maxSumSoFar = -2147483648;
//    int curSum = 0;
//    int a = b = s = i = 0;
//    for( i = 0; i < array.length; i++ ) {
//        //当前最大和 + 当前下标的值
//        curSum += array[i];
//        if ( curSum > maxSumSoFar ) {
//            maxSumSoFar = curSum;
//            //s 是子数组开始下标
//            a = s;
//            //b 是子数组结束下标
//            b = i;
//        }
//        //如果curSum小于0， 需要重设curSum的值和开始下标
//        if( curSum < 0 ) {
//            curSum = 0; s = i + 1;
//        }
//    }
//    start = a;
//    end = b;
//    maxSum = maxSumSoFar;
//}
// 思路：基于Kadane算法，从传入数组的第一项开始向后累加，比较累加和，当前和大于之前和时，更新子数组开始下标和结束下标，当和为负值时丢弃，从下一个索引开始重新累加，直到数组最后一项。
- (NSArray *)maxSubArrayIn:(NSArray *) array {
    // maxSumSoFar给最小值，因为数组内可能有负数
    int maxSumSoFar = -INT_MIN;
    // curSum: 记录当前和，maxSum：记录最大和
    int curSum = 0, maxSum;
    // a:当前最大子数组开始下标 b:当前最大子数组结束下标 s:开始的下标
    int a = 0, b = 0, s = 0, i = 0;
    for( i = 0; i < array.count; i++ ) {
        //当前最大和 + 当前下标的值
        curSum += (int)array[i];
        if ( curSum > maxSumSoFar ) {
            maxSumSoFar = curSum;
            //s 是子数组开始下标
            a = s;
            //b 是子数组结束下标
            b = i;
        }
        //如果curSum小于0， 需要重设curSum的值和开始下标
        if( curSum < 0 ) {
            curSum = 0;
            s = i + 1;
        }
    }
    // 根据最终的a, b值截取和最大的连续子数组
    NSArray * subArr = [array subarrayWithRange:NSMakeRange(a, b - a + 1)];
    maxSum = maxSumSoFar;
    return subArr;
}

@end
