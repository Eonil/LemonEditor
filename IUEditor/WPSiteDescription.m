//
//  WPSiteDescription.m
//  IUEditor
//
//  Created by jd on 2014. 7. 14..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "WPSiteDescription.h"

@implementation WPSiteDescription

- (id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    [self.undoManager disableUndoRegistration];

    [self.css setValue:@(110) forTag:IUCSSTagPixelY];
    [self.css setValue:@(450) forTag:IUCSSTagPixelWidth];
    [self.css eradicateTag:IUCSSTagPixelHeight];
    [self.css eradicateTag:IUCSSTagBGColor];
    
    self.enableCenter = YES;
    
    [self.css setValue:@(12) forTag:IUCSSTagFontSize];
    [self.css setValue:@(1.5) forTag:IUCSSTagLineHeight];
    [self.css setValue:@(IUAlignCenter) forTag:IUCSSTagTextAlign];
    [self.css setValue:[NSColor rgbColorRed:76 green:76 blue:76 alpha:1] forTag:IUCSSTagFontColor];
    
    [self.undoManager enableUndoRegistration];
    return self;
}

- (NSString*)sampleInnerHTML{
    return @"This is Site Description. Contact j@jdlab.org for more information.";
}

- (NSString*)code{
    return @"<?bloginfo('description')?>";
}

- (BOOL)shouldCompileFontInfo{
    return YES;
}

@end
