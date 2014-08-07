//
//  WPArticleTitle.m
//  IUEditor
//
//  Created by jd on 2014. 7. 15..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "WPArticleTitle.h"

@implementation WPArticleTitle
- (id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    self.positionType = IUPositionTypeFloatLeft;
    return self;
}

-(NSString*)code{
    return @"<?php the_title(); ?>";
}

- (NSString*)sampleHTML{
    return @"Lorem ipsum dolor sit amet, consectetur adipisicing elit.";
}

- (BOOL)shouldCompileFontInfo{
    return YES;
}

@end
