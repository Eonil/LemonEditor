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
    self.lineHeightAuto = NO;
    [self.css eradicateTag:IUCSSTagPixelHeight];
    [self.css eradicateTag:IUCSSTagBGColor];
    
    [self.css setValue:@(2.0) forTag:IUCSSTagLineHeight];
    [self.css setValue:@(-20) forTag:IUCSSTagPixelY];
    [self.css setValue:@(IUAlignRight) forTag:IUCSSTagTextAlign];
    [self.css setValue:[NSColor colorWithWhite:155.f/256.f alpha:1] forTag:IUCSSTagFontColor];

    return self;
}

-(NSString*)code{
    return @"<?php echo get_the_date(); ?>";
}

- (NSString*)sampleInnerHTML{
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

- (BOOL)canRemoveIUByUserInput{
    return NO;
}

@end
