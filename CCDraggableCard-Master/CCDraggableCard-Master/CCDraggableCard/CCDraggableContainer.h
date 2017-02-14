//
//  CCDraggableContainer.h
//  CCDraggableCard-Master
//
//  Created by jzzx on 16/7/6.
//  Copyright © 2016年 Zechen Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CCDraggableConfig.h"
#import "CCDraggableCardView.h"

@class CCDraggableContainer;


/**
 Delegate
 */
@protocol CCDraggableContainerDelegate <NSObject>
/** 左滑 或 右滑的过程中，外部通过此方法做相应的UI 或 交互 */
- (void)draggableContainer:(CCDraggableContainer *)draggableContainer
        draggableDirection:(CCDraggableDirection)draggableDirection
                widthRatio:(CGFloat)widthRatio
               heightRatio:(CGFloat)heightRatio;
/** card点击事件 */
- (void)draggableContainer:(CCDraggableContainer *)draggableContainer
                  cardView:(CCDraggableCardView *)cardView
            didSelectIndex:(NSInteger)didSelectIndex;
/** 滑动到最后一张card，在此做相应的操作 */
- (void)draggableContainer:(CCDraggableContainer *)draggableContainer
 finishedDraggableLastCard:(BOOL)finishedDraggableLastCard;

@end

/**
 DataSource
 */
@protocol CCDraggableContainerDataSource <NSObject>

@required
/** 在此提供继承于CCDraggableCardView的card，并给card传入相应的数据源 */
- (CCDraggableCardView *)draggableContainer:(CCDraggableContainer *)draggableContainer
                               viewForIndex:(NSInteger)index;
/** 提供一共有多少个card */
- (NSInteger)numberOfIndexs;

@end

/**
 CCDraggableContainer
 */
@interface CCDraggableContainer : UIView

@property (nonatomic, weak) IBOutlet id <CCDraggableContainerDelegate>delegate;
@property (nonatomic, weak) IBOutlet id <CCDraggableContainerDataSource>dataSource;

/** 暂时没有任何作用 */
@property (nonatomic) CCDraggableStyle     style;

/** 拖拽的方向 */
@property (nonatomic) CCDraggableDirection direction;

/** 容器初始化方法 */
- (instancetype)initWithFrame:(CGRect)frame style:(CCDraggableStyle)style;

/** 通过按钮实现 like or dislike */
- (void)removeForDirection:(CCDraggableDirection)direction;

/** 充值数据（包括初始化） */
- (void)reloadData;

@end
