//
//  IUHeader.m
//  IUEditor
//
//  Created by JD on 3/31/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUHeader.h"

@implementation IUHeader

-(id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    if(self){
        [self.css eradicateTag:IUCSSTagPixelWidth];
        [self.css setValue:@(120) forTag:IUCSSTagPixelHeight forViewport:IUCSSDefaultViewPort];
        [self.css setValue:[NSColor rgbColorRed:50 green:50 blue:50 alpha:1] forTag:IUCSSTagBGColor forViewport:IUCSSDefaultViewPort];
        
        self.positionType = IUPositionTypeRelative;
        self.overflowType = IUOverflowTypeVisible;
        
        
        IUBox *titleBox = [[IUBox alloc] initWithProject:project options:options];
        [titleBox.css setValue:@(140) forTag:IUCSSTagPixelWidth forViewport:IUCSSDefaultViewPort];
        [titleBox.css setValue:@(34) forTag:IUCSSTagPixelHeight forViewport:IUCSSDefaultViewPort];
        [titleBox.css setValue:@(43) forTag:IUCSSTagPixelY forViewport:IUCSSDefaultViewPort];
        [titleBox.css setValue:@(24) forTag:IUCSSTagFontSize forViewport:IUCSSDefaultViewPort];
        [titleBox.css setValue:@(IUAlignCenter) forTag:IUCSSTagTextAlign forViewport:IUCSSDefaultViewPort];
        [titleBox.css setValue:[NSColor rgbColorRed:153 green:153 blue:153 alpha:1] forTag:IUCSSTagFontColor forViewport:IUCSSDefaultViewPort];
        [titleBox.css setValue:nil forTag:IUCSSTagBGColor forViewport:IUCSSDefaultViewPort];
        [titleBox.css setValue:@"Helvetica" forTag:IUCSSTagFontName forViewport:IUCSSDefaultViewPort];
        
        titleBox.positionType = IUPositionTypeAbsoluteCenter;
        titleBox.textType = IUTextTypeH1;
        titleBox.text = @"Header Area";
        
        [self addIU:titleBox error:nil];
        self.positionType = IUPositionTypeRelative;
    }
    return self;
}

-(BOOL)shouldRemoveIUByUserInput{
    return NO;
}

- (BOOL)canChangeOverflow{
    return NO;
}
- (BOOL)canChangePositionType{
    return NO;
}

- (BOOL)hasX{
    return NO;
}

- (BOOL)hasY{
    return NO;
}

- (BOOL)hasWidth{
    return NO;
}

- (BOOL)canChangeXByUserInput{
    return NO;
}

- (BOOL)canChangeYByUserInput{
    return NO;
}

- (BOOL)canChangeWidthByUserInput{
    return NO;
}

- (BOOL)canCopy{
    return NO;
}
@end
