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
    [self.css setValue:@(2.0) forTag:IUCSSTagLineHeight];
    [self.css setValue:@(IUAlignLeft) forTag:IUCSSTagTextAlign];
    [self.css setValue:@(YES) forTag:IUCSSTagWidthUnitIsPercent];
    [self.css setValue:@(100) forTag:IUCSSTagPercentWidth];
    [self.css setValue:@(15) forTag:IUCSSTagFontSize];
    [self.css eradicateTag:IUCSSTagBGColor];
    
    NSString *res = [[NSBundle mainBundle] pathForResource:@"loremipsum" ofType:@"txt"];
    self.sampleText = [[NSString stringWithContentsOfFile:res encoding:NSUTF8StringEncoding error:nil] stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    return self;
}

- (void)setSampleText:(NSString *)sampleText{
    if ([sampleText length] == 0) {
        NSString *res = [[NSBundle mainBundle] pathForResource:@"loremipsum" ofType:@"txt"];
        _sampleText = [[NSString stringWithContentsOfFile:res encoding:NSUTF8StringEncoding error:nil] stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    }
    else {
        _sampleText = sampleText;
    }
    [self updateHTML];
}

- (NSString*)sampleInnerHTML{
    return [NSString stringWithFormat:@"<p>%@</p>", _sampleText];
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFromObject:self withProperties:[WPArticleBody properties]];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    [aDecoder decodeToObject:self withProperties:[WPArticleBody properties]];
    return self;
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

- (BOOL)canRemoveIUByUserInput{
    return NO;
}


@end
