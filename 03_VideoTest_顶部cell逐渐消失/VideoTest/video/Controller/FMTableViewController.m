//
//  FMTableViewController.m
//  VideoTest
//
//  Created by Windy on 2016/11/7.
//  Copyright © 2016年 Windy. All rights reserved.
//

#import "FMTableViewController.h"
#import "FMNormalChatCell.h"
#import "FMDialogModel.h"
#import "UIView+Frame.h"

#define Screen_Width [[UIScreen mainScreen] bounds].size.width
#define Screen_Height [[UIScreen mainScreen] bounds].size.height
@interface FMTableViewController ()

/** 聊天记录数组 */
@property (nonatomic, strong) NSMutableArray *chatArr;
/**  */
@property (nonatomic, assign) CGFloat offSet;

@end

static NSString *normalCellID = @"normal";
@implementation FMTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingTableView];
}

- (void)settingTableView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FMNormalChatCell class]) bundle:nil] forCellReuseIdentifier:normalCellID];
    self.tableView.contentInset = UIEdgeInsetsZero;
}

- (void)viewWillLayoutSubviews {
    if (self.tableView.x == 12.5) {
        return;
    }
    
    [self.tableView setFrame:CGRectMake(12.5, 65, Screen_Width - 50, Screen_Height / 2 - 120)];
}

/** 初始化聊天记录数组 */
- (NSMutableArray *)chatArr {
    if (!_chatArr) {
        _chatArr = [[NSMutableArray alloc] init];
    }
    return _chatArr;
}

//直播过程中收到公聊
- (void)recivePublicChatMessage:(NSDictionary *)message {
    NSLog(@"%@",message);
    if (message == nil || [message count] == 0) return;
    FMDialogModel *dialog = [[FMDialogModel alloc] init];
    dialog.isPublicChat = YES;
    dialog.content = message[@"content"];
    dialog.username = message[@"username"];
    dialog.viewerId = message[@"userid"];
    dialog.avatar = message[@"useravatar"];
    dialog.dataType = NS_CONTENT_TYPE_CHAT;
    [_chatArr addObject:dialog];
    [self.tableView reloadData];
    NSIndexPath *indexPatLast = [NSIndexPath indexPathForItem:([_chatArr count] - 1) inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPatLast atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FMNormalChatCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellID];
    //    cell.textLabel.text = [NSString stringWithFormat:@"群聊 %ld",indexPath.row];
    //    cell.textLabel.textColor = [UIColor greenColor];
    //    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    //    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

#pragma mark==TableviewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}
/** 逐渐消失 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        NSArray *visibleCells = [self.tableView visibleCells];
        if (visibleCells.count >= 2) {
            FMNormalChatCell *cell0 = visibleCells[0];
            FMNormalChatCell *cell1 = visibleCells[1];
            CGFloat offSetY = self.tableView.contentOffset.y;
            CGFloat cell_H = cell1.y - cell0.y;
            if (offSetY - _offSet) {
                cell1.alpha = 1 - (offSetY - cell0.y) / cell_H;
            } else {
                cell0.alpha = 1;
            }
            _offSet = offSetY;
//            NSLog(@" --- %f --- %f --- %f", cell_H, offSetY, cell0.alpha);
        }
    }
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView == self.tableView) {
//        NSArray *visibleCells = [self.tableView visibleCells];
//        if (visibleCells.count >= 3) {
//            FMNormalChatCell *cell0 = visibleCells[0];
//            FMNormalChatCell *cell1 = visibleCells[1];
//            FMNormalChatCell *cell2 = visibleCells[2];
//            CGFloat offSetY = self.tableView.contentOffset.y;
//            CGFloat cell_H = cell2.y - cell0.y;
//            NSLog(@"--- %f --- %f", cell2.y - offSetY, cell_H);
//            if (offSetY - _offSet) {
////                cell0.alpha = 1 - (offSetY - cell0.y) / cell_H;
//                cell1.alpha = (cell2.y - offSetY) / cell_H;
//            } else {
//                cell0.alpha = 1;
//            }
//            _offSet = offSetY;
//            //            NSLog(@" --- %f --- %f --- %f", cell_H, offSetY, cell0.alpha);
//        }
//    }
//}
/** 停止后恢复alpha */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        NSArray *visibleCells = [self.tableView visibleCells];
        if (visibleCells.count) {
            [visibleCells enumerateObjectsUsingBlock:^(FMNormalChatCell *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.alpha = 1;
            }];
        }
    }
}

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)   decelerate {
//    if (!decelerate) {
//        if (scrollView == self.tableView) {
//            NSArray *visibleCells = [self.tableView visibleCells];
//            if (visibleCells.count) {
//                [visibleCells enumerateObjectsUsingBlock:^(FMNormalChatCell *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    obj.alpha = 1;
//                }];
//            }
//        }
//    }
//}

@end
