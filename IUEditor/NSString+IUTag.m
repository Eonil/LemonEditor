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
    if ([self isEqualToTag:IUCSSTagPixelWidth] || [self isEqualToTag:IUCSSTagPixelHeight] || [self isEqualToTag:IUCSSTagPercentHeight] || [self isEqualToTag:IUCSSTagPercentWidth]
        || [self isEqualToTag:IUCSSTagPixelX] || [self isEqualToTag:IUCSSTagPercentX] || [self isEqualToTag:IUCSSTagPixelY] || [self isEqualToTag:IUCSSTagPercentY]) {
        return YES;
    }
    return NO;
}


- (BOOL)isHoverTag{
    if ([self isEqualToTag:IUCSSTagHoverBGImagePositionEnable] || [self isEqualToTag:IUCSSTagHoverBGImageX] || [self isEqualToTag:IUCSSTagHoverBGImageY]
        || [self isEqualToTag:IUCSSTagHoverBGColorEnable]|| [self isEqualToTag:IUCSSTagHoverBGColor]|| [self isEqualToTag:IUCSSTagHoverTextColorEnable]
        || [self isEqualToTag:IUCSSTagHoverTextColor]) {
        return YES;
    }
    return NO;
}

@end
