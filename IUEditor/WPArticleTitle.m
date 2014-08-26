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
    self.positionType = IUPositionTypeRelative;
    [self.css setValue:nil forTag:IUCSSTagBGColor];
    self.lineHeightAuto = NO;
    [self.css eradicateTag:IUCSSTagPixelHeight];
    [self.css setValue:@(2.0) forTag:IUCSSTagLineHeight];
    [self.css setValue:@(24) forTag:IUCSSTagFontSize];
    [self.css setValue:@(700) forTag:IUCSSTagPixelWidth];

    [self.css setValue:@(IUAlignLeft) forTag:IUCSSTagTextAlign];
    return self;
}

-(NSString*)code{
    return @"<a href=\"<?php the_permalink(); ?>\"><?php the_title(); ?></a>";
}

- (NSString*)sampleInnerHTML{
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

- (BOOL)canRemoveIUByUserInput{
    return NO;
}

@end
