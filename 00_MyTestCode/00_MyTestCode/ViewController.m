//
//  ViewController.m
//  00_MyTestCode
//
//  Created by Zhouheng on 2019/8/14.
//  Copyright © 2019 tataUFO. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

// sv 的contentsize 自行适应
- (void)scrollViewContentTest {
    
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(100, 100, 200, 80)];
    sv.backgroundColor = [UIColor purpleColor];
    
    [self.view addSubview:sv];
    UIView *containerView = [UIView new];
    
    [sv addSubview:containerView];
    containerView.backgroundColor = [UIColor cyanColor];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(sv);
    }];
    
    UIView *leftView = [UIView new];
    leftView.backgroundColor = [UIColor orangeColor];
    [containerView addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(containerView);
        make.width.equalTo(@(100));
        make.height.equalTo(@(80));
    }];
    
    UIView *rightView = [UIView new];
    rightView.backgroundColor = [UIColor redColor];
    [containerView addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(containerView);
        make.width.equalTo(@(100));
        make.height.equalTo(@(80));
    }];
    
    UIView *middleView = [UIView new];
    middleView.backgroundColor = [UIColor blueColor];
    [containerView addSubview:middleView];
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView.mas_right);
        make.top.equalTo(containerView);
        make.right.equalTo(rightView.mas_left);
        make.width.equalTo(@(100));
        make.height.equalTo(@(80));
    }];
    
}

- (void)swiftSubString {
    /*
     
     var length: Int {
     return self.count
     }
     
     subscript (i: Int) -> String {
     return self[i ..< i + 1]
     }
     
     func substring(fromIndex: Int) -> String {
     return self[min(fromIndex, length) ..< length]
     }
     
     func substring(toIndex: Int) -> String {
     return self[0 ..< max(0, toIndex)]
     }
     
     subscript (r: Range<Int>) -> String {
     let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)), upper: min(length, max(0, r.upperBound))))
     let start = index(startIndex, offsetBy: range.lowerBound)
     let end = index(start, offsetBy: range.upperBound - range.lowerBound)
     return String(self[start ..< end])
     }var length: Int {
     return self.count
     }
     
     subscript (i: Int) -> String {
     return self[i ..< i + 1]
     }
     
     func substring(fromIndex: Int) -> String {
     return self[min(fromIndex, length) ..< length]
     }
     
     func substring(toIndex: Int) -> String {
     return self[0 ..< max(0, toIndex)]
     }
     
     subscript (r: Range<Int>) -> String {
     let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)), upper: min(length, max(0, r.upperBound))))
     let start = index(startIndex, offsetBy: range.lowerBound)
     let end = index(start, offsetBy: range.upperBound - range.lowerBound)
     return String(self[start ..< end])
     }
     */
}

@end
