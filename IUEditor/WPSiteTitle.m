//
//  WPSiteTitle.m
//  IUEditor
//
//  Created by jd on 2014. 7. 14..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "WPSiteTitle.h"

@implementation WPSiteTitle

- (id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    [self.undoManager disableUndoRegistration];
    
    [self.css setValue:@(300) forTag:IUCSSTagPixelWidth];
    [self.css eradicateTag:IUCSSTagPixelHeight];
    [self.css eradicateTag:IUCSSTagBGColor];
    
    
    [self.css setValue:@(30) forTag:IUCSSTagFontSize];
    [self.css setValue:@(1.5) forTag:IUCSSTagLineHeight];
    [self.css setValue:@(IUAlignCenter) forTag:IUCSSTagTextAlign];
    [self.css setValue:[NSColor rgbColorRed:51 green:51 blue:51 alpha:1] forTag:IUCSSTagFontColor];    
    
    [self.undoManager enableUndoRegistration];
    return self;
}

- (NSString*)sampleInnerHTML{
    return @"Site Title";
}

- (NSString*)code{
    return @"<h1><a href=\"<?php echo home_url(); ?>\"><?bloginfo()?></a></h1>";
}

- (BOOL)shouldCompileFontInfo{
    return YES;
}

@end
