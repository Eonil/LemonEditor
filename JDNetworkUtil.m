//
//  JDNetworkUtil.m
//  IUEditor
//
//  Created by jd on 2014. 7. 9..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "JDNetworkUtil.h"
#import "JDShellUtil.h"

@implementation JDNetworkUtil

+ (BOOL) isPortAvailable:(NSInteger)port{
    NSString *stdOut;
    NSString *stdErr;
    [JDShellUtil execute:@"lsof -i tcp:8000 | grep LISTEN | awk -F  ' ' '{print $2}'" stdOut:&stdOut stdErr:&stdErr];
    
    NSAssert(stdErr, stdErr);
    if ([stdOut length]) {
        return NO;
    }
    return YES;
}

+ (NSInteger) pidOfPort:(NSInteger)port{
    NSString *stdOut;
    NSString *stdErr;
    [JDShellUtil execute:@"lsof -i tcp:8000 | grep LISTEN | awk -F  ' ' '{print $2}'" stdOut:&stdOut stdErr:&stdErr];
    
    NSAssert(stdErr, stdErr);
    if ([stdOut length]) {
        return [stdOut integerValue];
    }
    return NSNotFound;
}


@end
