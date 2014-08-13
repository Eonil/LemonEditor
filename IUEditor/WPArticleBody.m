//
//  WPArticleBody.m
//  IUEditor
//
//  Created by jd on 2014. 8. 7..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "WPArticleBody.h"

@implementation WPArticleBody

- (id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    self.positionType = IUPositionTypeRelative;
    [self.css eradicateTag:IUCSSTagPixelHeight];
    [self.css setValue:@"1.3" forTag:IUCSSTagLineHeight];
    [self.css setValue:@(IUAlignLeft) forTag:IUCSSTagTextAlign];
    
    [self.css setValue:@(800) forTag:IUCSSTagPixelWidth forViewport:IUCSSDefaultViewPort];
    return self;
}

- (NSString*)sampleHTML{
    NSString *res = [[NSBundle mainBundle] pathForResource:@"loremipsum" ofType:@"txt"];
    return [[NSString stringWithContentsOfFile:res encoding:NSUTF8StringEncoding error:nil] stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
}

- (NSString*)code{
    return @"<?php the_content(); ?>";
}

- (BOOL)shouldCompileFontInfo{
    return YES;
}

- (BOOL)canCopy{
    return NO;
}

@end
