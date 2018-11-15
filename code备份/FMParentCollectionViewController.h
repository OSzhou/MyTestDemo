//
//  FMParentCollectionViewController.h
//  SenyintCollegeStudent_2.0
//
//  Created by Windy on 2017/3/21.
//  Copyright © 2017年 任亚丽. All rights reserved.
//

#import "SCBaseViewController.h"

typedef NS_ENUM(NSUInteger, FMRefreshType){
    FMRefreshTypeHeader = 1,
    FMRefreshTypeFooter = 1 << 1,
    FMRefreshTypeAll = FMRefreshTypeHeader | FMRefreshTypeFooter
};
@interface FMParentCollectionViewController : SCBaseViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic) NSMutableArray * dataArray;
@property (nonatomic, assign) FMRefreshType refreshType;
@property (nonatomic, copy) NSString * urlStr;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, assign) CGFloat topHeight;
@property (nonatomic, assign) CGFloat collectionViewY;

- (NSArray *)createDataObjectWithJSONNode:(id)node;
@end
