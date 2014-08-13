//
//  WPArticleDate.m
//  IUEditor
//
//  Created by jd on 2014. 7. 16..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "WPArticleDate.h"
#import "WPArticle.h"

@implementation WPArticleDate

- (id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    self.positionType = IUPositionTypeFloatRight;
    return self;
}

-(NSString*)code{
    return @"<?php echo get_the_date(); ?>";
}

- (NSString*)sampleHTML{
    return @"Dec. 24. 2014.";
}

- (BOOL)shouldCompileFontInfo{
    return YES;
}


- (BOOL)canMoveToOtherParent{
    return NO;
}

- (BOOL)canCopy{
    return NO;
}

@end
