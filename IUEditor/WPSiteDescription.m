//
//  WPSiteDescription.m
//  IUEditor
//
//  Created by jd on 2014. 7. 14..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "WPSiteDescription.h"

@implementation WPSiteDescription

- (id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    self.innerHTML = @"<? bloginfo('description'); ?>";
    return self;
}

@end
