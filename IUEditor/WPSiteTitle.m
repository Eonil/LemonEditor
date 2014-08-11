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
    [self.css setValue:@(300) forTag:IUCSSTagPixelWidth];
    [self.css setValue:@(40) forTag:IUCSSTagPixelHeight];
    [self.css setValue:@(30) forTag:IUCSSTagFontSize];
    return self;
}

- (NSString*)sampleHTML{
    return @"Site Title";
}

- (NSString*)code{
    return @"<?bloginfo()?>";
}

- (BOOL)shouldCompileFontInfo{
    return YES;
}

@end
