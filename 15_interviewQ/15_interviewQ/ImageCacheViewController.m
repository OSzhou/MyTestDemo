//
//  ImageCacheViewController.m
//  15_interviewQ
//
//  Created by Windy on 2018/3/14.
//  Copyright © 2018年 Windy. All rights reserved.
//

#import "ImageCacheViewController.h"

typedef void (^FMCallBlock)(UIImage *);
typedef void (^FMFileContentBlock)(NSData *);
@interface ImageCacheViewController ()

/** 内存缓存的图片 */
@property (nonatomic, strong) NSMutableDictionary *images;
/** 队列对象 */
@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation ImageCacheViewController

- (NSOperationQueue *)queue {
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 3;
    }
    return _queue;
}

- (NSMutableDictionary *)images {
    if (!_images) {
        _images = [NSMutableDictionary dictionary];
    }
    return _images;
}

- (void)downloadImageByURL:(NSString *)url image:(FMCallBlock) callback {
    // 先从内存缓存中取出图片
    UIImage *image;
    if (image) { // 内存中有图片
        !callback?:callback(self.images[url]);
    } else{ // 下载图片
        [self.queue addOperationWithBlock:^{
            // 下载图片
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            UIImage *image = [UIImage imageWithData:data];
            
            // 请求完成返回
            !callback?:callback(image);
            
            // 存到字典中
            if (_images.count>100) {
                [_images removeObjectForKey:[[_images allKeys] firstObject]];
            }
            self.images[url] = image;
        }];
    }
}

- (void)asyncConcurrentWith:(NSArray *)fileNames content:(FMFileContentBlock)contentBlock {
    // 1.获得全局的并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 2.将任务加入队列
    NSLock *lock = [[NSLock alloc] init];
    // 获得Library/Caches文件夹
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    for (int i = 0; i < fileNames.count; i++) {
        dispatch_async(queue, ^{
            [lock lock];
            // 获得文件名
            NSString *filename = fileNames[i];
            // 计算出文件的全路径
            NSString *file = [cachesPath stringByAppendingPathComponent:filename];
            // 加载沙盒的文件数据
            NSData *data = [NSData dataWithContentsOfFile:file];
            !contentBlock?:contentBlock(data);
            [lock unlock];
        });
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
