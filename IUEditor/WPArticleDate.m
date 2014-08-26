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
    [self.undoManager disableUndoRegistration];
    
    //css
    self.positionType = IUPositionTypeRelative;
    
    [self.css setValue:@(10) forTag:IUCSSTagPixelY];
    [self.css setValue:@(YES) forTag:IUCSSTagWidthUnitIsPercent];
    [self.css setValue:@(30) forTag:IUCSSTagPercentWidth];
    [self.css eradicateTag:IUCSSTagPixelHeight];
    [self.css eradicateTag:IUCSSTagBGColor];

    
    self.enableCenter = YES;
    
    [self.css setValue:@(14) forTag:IUCSSTagFontSize];
    [self.css setValue:@(2.0) forTag:IUCSSTagLineHeight];
    [self.css setValue:@(IUAlignCenter) forTag:IUCSSTagTextAlign];
    [self.css setValue:@"HelveticaNeue-Light" forTag:IUCSSTagFontName];
    [self.css setValue:[NSColor rgbColorRed:154 green:154 blue:154 alpha:1] forTag:IUCSSTagFontColor];


    [self.undoManager enableUndoRegistration];
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
