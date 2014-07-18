//
//  JDFTPModule.m
//  IUEditor
//
//  Created by jd on 2014. 7. 17..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "JDUploadUtil.h"
#import "JDShellUtil.h"

@interface JDUploadUtil() <JDShellUtilPipeDelegate>
@end

@implementation JDUploadUtil {
    JDShellUtil *util;
}

- (BOOL)upload{
    if (self.protocol == JDSCP) {
        NSString *src = [[NSBundle mainBundle] pathForResource:@"JDUploadSCP" ofType:@"sh"];
        util = [[JDShellUtil alloc] init];
        NSString *to = [NSString stringWithFormat:@"%@@%@:%@", self.user, self.host, self.remoteDirectory];
        NSString *command = [NSString stringWithFormat:@"%@ %@ %@ %@", src, self.localDirectory, to, self.password];
        [util execute:command delegate:self];
    }
    else {
        assert(0); // not coded yet
    }
    return YES;
}

- (BOOL)download{
    if (self.protocol == JDSCP) {
        NSString *src = [[NSBundle mainBundle] pathForResource:@"JDUploadSCP" ofType:@"sh"];
        util = [[JDShellUtil alloc] init];
        NSString *from = [NSString stringWithFormat:@"%@@%@:%@", self.user, self.host, self.remoteDirectory];
        NSString *command = [NSString stringWithFormat:@"%@ %@ %@ %@", src, from , self.localDirectory, self.password];
        [util execute:command delegate:self];
    }
    else {
        assert(0); // not coded yet
    }
    return YES;
}

- (BOOL)isUploading{
    return [util.task isRunning];
}


-(void)shellUtil:(JDShellUtil *)util standardErrorDataReceived:(NSData *)error{
    NSString *str = [[NSString alloc] initWithData:error encoding:NSUTF8StringEncoding];
    NSLog(str, nil);

    if (str) {
        [self.delegate uploadUtilReceivedStdError:str];
    }
}

- (void)shellUtilExecutionFinished:(JDShellUtil *)_util{
    [self.delegate uploadFinished:[_util.task terminationStatus]];
}

- (void)shellUtil:(JDShellUtil *)util standardOutputDataReceived:(NSData *)data{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(str, nil);
    if (str) {
        [self.delegate uploadUtilReceivedStdOutput:str];
    }
}
@end
