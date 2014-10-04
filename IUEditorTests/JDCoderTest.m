//
//  JDCoderTest.m
//  IUEditor
//
//  Created by jd on 10/2/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "IUBox.h"

@interface JDCoderTest : XCTestCase

@end

@implementation JDCoderTest {
    IUBox *testBox;
    IUBox *childBox1;
    IUBox *childBox2;
}

- (void)setUp {
    [super setUp];
    NSLog(@"test");
    testBox = [[IUBox alloc] initWithProject:nil options:nil];
    testBox.htmlID = @"THIS_IS_HTMLID";
    [testBox.css setValue:@"VALUETEST" forTag:@"IUCSSTagForTest"];
    [testBox.css setValue:@(10) forTag:@"IUCSSTagForTestNum"];
    
    childBox1 = [[IUBox alloc] initWithProject:nil options:nil];
    childBox1.htmlID = @"ChildBox1";

    childBox2 = [[IUBox alloc] initWithProject:nil options:nil];
    childBox2.htmlID = @"ChildBox2";
    
    [testBox addIU:childBox1 error:nil];
    [testBox addIU:childBox2 error:nil];

    childBox1.link = childBox2;
    childBox2.link = childBox1;
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test1_IUBoxEncoding1{
    // This is an example of a functional test case.
    JDCoder *coder = [[JDCoder alloc] init];
    [coder encodeRootObject:testBox];
    IUBox *resultBox = [coder decodedAndInitializeObject];

    XCTAssert([resultBox.htmlID isEqualToString:@"THIS_IS_HTMLID"], @"Pass");
}

- (void)test2_IUBoxCSS{
    // This is an example of a functional test case.
    JDCoder *coder = [[JDCoder alloc] init];
    [coder encodeRootObject:testBox];
    IUBox *resultBox = [coder decodedAndInitializeObject];
    
    XCTAssert([[resultBox.css effectiveValueForTag:@"IUCSSTagForTest" forViewport:IUCSSDefaultViewPort] isEqualToString:@"VALUETEST"], @"Pass");
    NSInteger result = [[resultBox.css effectiveValueForTag:@"IUCSSTagForTestNum" forViewport:IUCSSDefaultViewPort] integerValue];
    XCTAssert(result == 10, @"Pass");
}

- (void)test3_CoderSaveLoad{
    JDCoder *coder = [[JDCoder alloc] init];
    [coder encodeRootObject:testBox];
    NSString *tempDir = NSTemporaryDirectory();
    NSURL *fileURL = [NSURL fileURLWithPath:[tempDir stringByAppendingPathComponent:@"testBox.iuml"]];
    NSError *err;
    BOOL saveResult = [coder saveToURL:fileURL error:&err];
    XCTAssert(saveResult, @"Pass");
    JDCoder *loadCoder = [[JDCoder alloc] init];
    [loadCoder loadFromURL:fileURL error:&err];
    IUBox *resultBox = [loadCoder decodedAndInitializeObject];
    
    XCTAssert([[resultBox.css effectiveValueForTag:@"IUCSSTagForTest" forViewport:IUCSSDefaultViewPort] isEqualToString:@"VALUETEST"], @"Pass");
    NSInteger result = [[resultBox.css effectiveValueForTag:@"IUCSSTagForTestNum" forViewport:IUCSSDefaultViewPort] integerValue];
    XCTAssert(result == 10, @"Pass");
}

- (void)test4_children{
    JDCoder *coder = [[JDCoder alloc] init];
    [coder encodeRootObject:testBox];
    
    IUBox *resultBox = [coder decodedAndInitializeObject];
    IUBox *resultChildBox1 = [[resultBox children] objectAtIndex:0];
    
    XCTAssert([resultChildBox1.htmlID isEqualToString:@"ChildBox1"], @"Pass");
}

- (void)test5_selector{
    JDCoder *coder = [[JDCoder alloc] init];
    [coder encodeRootObject:testBox];
    
    IUBox *resultBox = [coder decodedAndInitializeObject];
    IUBox *resultChildBox1 = [[resultBox children] objectAtIndex:0];
    IUBox *resultChildBox2 = [[resultBox children] objectAtIndex:1];

    XCTAssert(resultChildBox1, @"Pass");
    XCTAssert(resultChildBox1.link == resultChildBox2, @"Pass");
    XCTAssert(resultChildBox2.link == resultChildBox1, @"Pass");
}

/*
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}
 */

@end
