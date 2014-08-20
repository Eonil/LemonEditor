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
    [self.css setValue:@(450) forTag:IUCSSTagPixelWidth];
    [self.css setValue:@(40) forTag:IUCSSTagPixelHeight];
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
