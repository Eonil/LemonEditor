//
//  WPContentCollection.m
//  IUEditor
//
//  Created by jw on 7/15/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "WPContentCollection.h"

@implementation WPContentCollection

- (void)setEnableDate:(BOOL)enableDate{
    enableDate = _enableDate;
    [self updateHTML];
}

- (void)setEnableTime:(BOOL)enableTime{
    enableTime = _enableTime;
    [self updateHTML];
}

- (void)setEnableCategory:(BOOL)enableCategory{
    enableCategory  = _enableCategory;
    [self updateHTML];
}
- (void)setEnableTag:(BOOL)enableTag{
    enableTag = _enableTag;
    [self updateHTML];
}


@end
