//
//  ViewController.m
//  StretchImageTest
//
//  Created by Windy on 2016/10/25.
//  Copyright © 2016年 Windy. All rights reserved.
//

#import "ViewController.h"
#import "Constant.h"
#import "FMTableView.h"
#import "UIButton+Extension.h"
#import "FMRuntimeTest.h"
#import "PopoverViewController.h"
#import "PopoverAnimator.h"
#import "UIImage+Circle.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *circleImage;

@property (nonatomic, strong) FMTableView *tv;
/**  */
@property (nonatomic, strong) PopoverAnimator *animator;
@end

@implementation ViewController
- (IBAction)popoverBtnclick:(UIButton *)sender {
    [self popoverView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    int i = 0;
    while (i++ < 5) {//打印5次（先判断再执行+1，最后执行语句）
        NSLog(@"test111 --- %zd", i);
        //1 2 3 4 5
    }
    int j = 0;
    while (++j < 5) {//打印4次（先+1再执行判断，最后执行语句）
        NSLog(@"test222 --- %zd", j);
        //1 2 3 4
    }
    /* _tv = [[FMTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _tv.alwaysBounceVertical = YES;
    _tv.delegate = self;
    _tv.dataSource = self;
    [self.view addSubview:_tv];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(50, 50, 100, 100);
    btn.cjr_acceptEventInterval = 1;
    btn.backgroundColor = [UIColor cyanColor];
    [btn addTarget:self action:@selector(testClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];*/
    //只设置两个圆角
//    [self justTwoCornerRadius];
//    [self labelTest];
//    [self runtimeTest];
    [self circleImageTest];
}

- (void)circleImageTest {
//    UIImage *image = [UIImage circleImage:[UIImage imageNamed:@"阿狸头像"] withParam:30.0f borderWidth:60.0 borderColor:[UIColor purpleColor]];
//    UIImage *img = [UIImage imageNamed:@"阿狸头像"];
//    UIImage *image = [UIImage createBorderImage:img withBorderColor:[UIColor redColor] WithWidth:2.0f];
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObject:@"0"];
    [arr addObject:@"1"];
    [arr addObject:@"2"];
    [arr insertObject:@"3" atIndex:2];
    NSLog(@" --- %@ --- %zd", arr[3], arr.count);
    UIImage *image = [UIImage imageWithClipImage:[UIImage imageNamed:@"阿狸头像"] borderWidth:0 borderColor:nil];
    self.circleImage.image = image;
}

- (void)popoverView {
    PopoverViewController *pc = [[PopoverViewController alloc] init];
    pc.modalPresentationStyle = UIModalPresentationCustom;
    pc.transitioningDelegate = self.animator;
    [self presentViewController:pc animated:YES completion:nil];
}

- (PopoverAnimator *)animator {
    if (!_animator) {
        _animator = [[PopoverAnimator alloc] init];
        _animator.presentFrame = CGRectMake(100, 56, 200, 200);
    }
    return _animator;
}

- (void)runtimeTest {
    FMRuntimeTest *test = [[FMRuntimeTest alloc] init];
    [test printAllIvarAndProperty];
}

- (void)labelTest {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 300, 30, 50)];
    label.backgroundColor = [UIColor cyanColor];
//    label.text = @"you will never make on your own!";
    label.text = @"中国中国中国中国中国";//@"abcdefghijklmnopqrst";
    label.font = [UIFont systemFontOfSize:13];
    NSString *text = label.text;
    CGFloat w = [text boundingRectWithSize:CGSizeMake(self.view.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.width;
    NSLog(@" --- %f", w);
    NSInteger length = label.text.length;
    /*
     {
     //以单词为显示单位显示，后面部分省略不显示。
     NSLineBreakByWordWrapping = 0,     	// Wrap at word boundaries, default
     //以字符为显示单位显示，后面部分省略不显示
     NSLineBreakByCharWrapping,		// Wrap at character boundaries
     //剪切与文本宽度相同的内容长度，后半部分被删除。
     NSLineBreakByClipping,		// Simply clip
     //前面部分文字以……方式省略，显示尾部文字内容。
     NSLineBreakByTruncatingHead,	// Truncate at head of line: "...wxyz"
     //结尾部分的内容以……方式省略，显示头的文字内容。
     NSLineBreakByTruncatingTail,	// Truncate at tail of line: "abcd..."
     //中间的内容以……方式省略，显示头尾的文字内容。
     NSLineBreakByTruncatingMiddle	// Truncate middle of line:  "ab...yz"
     }
     */
//    label.lineBreakMode = NSLineBreakByClipping;
//    NSInteger W = (int)w;
    [self.view addSubview:label];
    NSInteger index = 23.f / w * length;
    NSString *subStr = [label.text substringToIndex:index];
    
    NSLog(@" --- %@", subStr);
//    NSLog(@" --- %lu", strlen(p));const char *p = [str UTF8String];
}

- (void)justTwoCornerRadius {
    
    //view点阵化，增加流畅度(以下两行都是)
    /*
    [self.layer setShouldRasterize:YES];
    [self.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
     */
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(120, 10, 80, 80)];
    view2.backgroundColor = [UIColor redColor];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view2.bounds      byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight    cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view2.bounds;
    maskLayer.path = maskPath.CGPath;
    view2.layer.mask = maskLayer;
    [self.view addSubview:view2];
}

- (void)testClick {
    NSLog(@"123456");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"house"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"house"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"FMTest --- %zd", indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_tv.contentOffset.y < 0) {
        _tv.contentOffset = CGPointMake(0, 0);
    }
}

@end
