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

@implementation JDCoderTest

- (void)setUp {
    [super setUp];
    NSLog(@"test");
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testIUBoxEncoding {
    // This is an example of a functional test case.
    IUBox *testBox = [[IUBox alloc] initWithProject:nil options:nil];
    testBox.htmlID = @"HTML_ID";

    JDCoder *coder = [[JDCoder alloc] init];
    [coder encodeRootObject:testBox];
    IUBox *resultBox = [coder decodedAndInitializeObject];

    XCTAssert([resultBox.htmlID isEqualToString:@"HTML_ID"], @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
