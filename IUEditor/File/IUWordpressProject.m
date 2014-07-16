//
//  IUWordpressProject.m
//  IUEditor
//
//  Created by jd on 2014. 7. 14..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "IUWordpressProject.h"
#import "IUEventVariable.h"
@implementation IUWordpressProject

- (id)initWithCoder:(NSCoder *)aDecoder{
    return [super initWithCoder:aDecoder];
}

- (BOOL)runnable{
    return YES;
}

- (NSString*)buildPathForSheet:(IUSheet*)sheet{
    NSString *buildPath = [self.directoryPath stringByAppendingPathComponent:self.buildPath];
    if (sheet == nil) {
        return buildPath;
    }
    else {
        NSString *filePath = [[buildPath stringByAppendingPathComponent:sheet.name ] stringByAppendingPathExtension:@"php"];
        return filePath;
    }
}

@end
