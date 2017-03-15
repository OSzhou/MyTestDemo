//
//  _8_____UITests.m
//  08_单元测试UITests
//
//  Created by Windy on 2017/3/13.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface _8_____UITests : XCTestCase

@end

@implementation _8_____UITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    //一般默认设置为NO，用例出错后，就不往下执行了
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testUI {
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElement *button = app.buttons[@"点我"];
    [button tap];
    
    XCUIElement *backButton = [[[app.navigationBars[@"UIView"] childrenMatchingType:XCUIElementTypeButton] matchingIdentifier:@"Back"] elementBoundByIndex:0];
    [backButton tap];
    [button tap];
    [backButton tap];
    [button tap];
    [backButton tap];
    
//    XCUIApplication* app = [[XCUIApplication alloc] init];
//    //获得当前界面中的表视图
//    XCUIElement* tableView = [app.tables elementBoundByIndex:0];
//    XCUIElement* cell1 = [tableView.cells elementBoundByIndex:0];
//    //法1 推荐使用
//    XCTAssert(cell1.staticTexts[@"Welcome"].exists);
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

@end
