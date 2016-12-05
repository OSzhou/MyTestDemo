//
//  ViewController.m
//  WYTest
//
//  Created by Windy on 2016/10/21.
//  Copyright © 2016年 Windy. All rights reserved.
//

#import "ViewController.h"
#import <UIKit+AFNetworking.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (UIImage *)dd_cachedImageForRequest:(NSURLRequest *)request
{
    AFImageDownloader *downloader = [AFImageDownloader defaultInstance];
    // 内存缓存
    UIImage *cachedImage = [downloader.imageCache imageforRequest:request withAdditionalIdentifier:nil];
    if (!cachedImage) {
        // 内存缓存没有，读取硬盘缓存
        NSURLCache *urlCache = downloader.sessionManager.session.configuration.URLCache;
        NSCachedURLResponse *cacheResponse = [urlCache cachedResponseForRequest:request];
        if (cacheResponse.data) {
            cachedImage = [UIImage imageWithData:cacheResponse.data];
        }
    } else {//内存缓存 & 磁盘缓存 都没有，进行网络请求
        
    }
    return cachedImage;
}

@end
