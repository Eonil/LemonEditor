//
//  WPSiteTitle.m
//  IUEditor
//
//  Created by jd on 2014. 7. 14..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "WPSiteTitle.h"

@implementation WPSiteTitle

- (NSString*)sampleHTML{
    return @"Site title will be here.";
}

- (NSString*)code{
    return @"<?bloginfo()?>";
}

- (BOOL)shouldCompileFontInfo{
    return YES;
}

@end
