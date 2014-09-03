//
//  NSString+IUTag.m
//  IUEditor
//
//  Created by jd on 3/30/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "NSString+IUTag.h"

@implementation NSString (IUTag)
-(NSString*)pixelString{
    return [self stringByAppendingString:@"px"];
}
-(NSString*)percentString{
    return [self stringByAppendingString:@"%"];
}

-(BOOL)isFrameTag{
    if ([self isSameTag:IUCSSTagPixelWidth] || [self isSameTag:IUCSSTagPixelHeight] || [self isSameTag:IUCSSTagPercentHeight] || [self isSameTag:IUCSSTagPercentWidth]
        || [self isSameTag:IUCSSTagPixelX] || [self isSameTag:IUCSSTagPercentX] || [self isSameTag:IUCSSTagPixelY] || [self isSameTag:IUCSSTagPercentY]) {
        return YES;
    }
    return NO;
}


- (BOOL)isHoverTag{
    if ([self isSameTag:IUCSSTagHoverBGImagePositionEnable] || [self isSameTag:IUCSSTagHoverBGImageX] || [self isSameTag:IUCSSTagHoverBGImageY]
        || [self isSameTag:IUCSSTagHoverBGColorEnable]|| [self isSameTag:IUCSSTagHoverBGColor]|| [self isSameTag:IUCSSTagHoverTextColorEnable]
        || [self isSameTag:IUCSSTagHoverTextColor]) {
        return YES;
    }
    return NO;
}

@end
