//
//  IUServerInfo.m
//  IUEditor
//
//  Created by jd on 2014. 7. 21..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "IUServerInfo.h"

@implementation IUServerInfo

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeFromObject:self withProperties:[IUServerInfo properties]];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    [aDecoder decodeToObject:self withProperties:[IUServerInfo properties]];
    return self;
}

- (BOOL)isSyncValid{
    return [self.host length] && [self.remotePath length] && [self.syncUser length];
}

@end
