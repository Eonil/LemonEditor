//
//  JDShellUtil.h
//  IUEditor
//
//  Created by jd on 2014. 7. 10..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JDShellUtil;
@protocol JDShellUtilPipeDelegate <NSObject>
@required
- (void)shellUtil:(JDShellUtil*)util standardOutputDataReceived:(NSData*)data;
- (void)shellUtil:(JDShellUtil*)util standardErrorDataReceived:(NSData*)error;
@optional
- (void)shellUtilExecutionFinished:(JDShellUtil*)util;
@end

@interface JDShellUtil : NSObject

-(NSTask*)task;
-(void)stop;
/**
 write data to standard input.
 contray fuction of shellUtil: read:
 */
-(void)writeDataToStandardInput:(NSData*)data;

+(NSInteger)execute:(NSString*)file atDirectory:(NSString*)runPath arguments:(NSArray*)arguments stdOut:(NSString**)stdOutLog stdErr:(NSString**)stdErrLog;

+(NSInteger)execute:(NSString*)command stdOut:(NSString**)stdOutLog stdErr:(NSString**)stdErrLog;
+(NSInteger)execute:(NSString*)command;

-(int)execute:(NSString*)command delegate:(id <JDShellUtilPipeDelegate>)  delegate;
@end
