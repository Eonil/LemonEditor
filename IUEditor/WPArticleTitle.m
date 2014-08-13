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
    [self.css setValue:nil forTag:IUCSSTagBGColor];
    return self;
}

-(NSString*)code{
    return @"<?php the_title(); ?>";
}

- (NSString*)sampleHTML{
    return @"Here comes title of article. Elcitra fo eltit semoc ereh.";
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
