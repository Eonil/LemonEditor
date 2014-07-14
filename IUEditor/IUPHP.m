//
//  IUPHP.m
//  IUEditor
//
//  Created by jd on 2014. 7. 14..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "IUPHP.h"

@implementation IUPHP

- (NSString*)innerHTML{
    return [NSString stringWithFormat:@"<? %@ ?>", self.code];
}

@end
