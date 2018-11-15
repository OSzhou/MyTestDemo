//
//  SpliceImageController.m
//  05_DIYUI
//
//  Created by Smile on 16/05/2018.
//  Copyright © 2018 Windy. All rights reserved.
//

#import "SpliceImageController.h"

@interface SpliceImageController ()
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIImage*image1;
@property(nonatomic,strong)UIImage*image2;

@end

@implementation SpliceImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.imageView];
    [self spliceImage];
}

- (void)spliceImage {
    //创建队列组
    
    dispatch_group_t group = dispatch_group_create();
    
    //1.开子线程下载图片
    
    //创建队列(并发)
    
    dispatch_queue_t queue = dispatch_get_global_queue(0,0);
    
    //异步执行并发队列
    
    dispatch_group_async(group, queue, ^{
        
        //1.获取url地址
        
        NSURL*url = [NSURL URLWithString:@"https://imgsa.baidu.com/baike/c0=baike180,5,5,180,60/sign=b531c24482025aafc73f76999a84c001/b21c8701a18b87d6435d2f9b070828381f30fd13.jpg"];
        
        //2.下载图片
        
        NSData*data = [NSData dataWithContentsOfURL:url];
        
        //3.把二进制数据转换成图片
        
        self.image1= [UIImage imageWithData:data];
        
    });
    
    //下载图片2
    
    dispatch_group_async(group, queue, ^{
        
        //1.获取url地址
        
        NSURL*url = [NSURL URLWithString:@"https://imgsa.baidu.com/baike/c0=baike220,5,5,220,73/sign=62c273b38a13632701e0ca61f0e6cb89/8644ebf81a4c510faae40d756059252dd42aa5b9.jpg"];
        
        //2.下载图片
        
        NSData*data = [NSData dataWithContentsOfURL:url];
        
        //3.把二进制数据转换成图片
        
        self.image2= [UIImage imageWithData:data];
        
    });
    
    //合成
    
    dispatch_group_notify(group, queue, ^{
        
        //开启图形上下文
        
        UIGraphicsBeginImageContext(CGSizeMake(200,200));
        
        //画1
        
        [self.image1 drawInRect:CGRectMake(2,2,96,96)];
        [self.image1 drawInRect:CGRectMake(102,102,96,96)];
        //画2
        [self.image2 drawInRect:CGRectMake(102,2,96,96)];
        [self.image2 drawInRect:CGRectMake(2,102,96,96)];
        
        //根据图形上下文拿到图片
        
        UIImage*image =UIGraphicsGetImageFromCurrentImageContext();
        
        //关闭上下文
        
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.imageView.image= image;
            
        });
        
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --- lazy loading
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((Screen_W - 300) / 2, 20, 300, 300)];
        _imageView.backgroundColor = [UIColor cyanColor];
    }
    return _imageView;
}
@end
