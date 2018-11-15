//
//  RechargeVC.h
//  14_InAppPurchase
//
//  Created by Windy on 2017/7/7.
//  Copyright © 2017年 Windy. All rights reserved.
//

#define kSandboxVerifyURL @"https://sandbox.itunes.apple.com/verifyReceipt" //开发阶段沙盒验证URL
#define kAppStoreVerifyURL @"https://buy.itunes.apple.com/verifyReceipt" //实际购买验证URL
#import <StoreKit/StoreKit.h>
#import <UIKit/UIKit.h>

enum{
    IAP0p20=20,
    IAP1p100,
    IAP4p600,
    IAP9p1000,
    IAP24p6000,
}buyCoinsTag;

//代理
@interface RechargeVC : UIViewController <SKPaymentTransactionObserver,SKProductsRequestDelegate >
{
    int buyType;
}
- (void) requestProUpgradeProductData;


-(void)RequestProductData;


-(void)buy:(int)type;


- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;


-(void) PurchasedTransaction: (SKPaymentTransaction *)transaction;


- (void) completeTransaction: (SKPaymentTransaction *)transaction;


- (void) failedTransaction: (SKPaymentTransaction *)transaction;


-(void) paymentQueueRestoreCompletedTransactionsFinished: (SKPaymentTransaction *)transaction;


-(void) paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error;



- (void) restoreTransaction: (SKPaymentTransaction *)transaction;


-(void)provideContent:(NSString *)product;


-(void)recordTransaction:(NSString *)product;


@end
