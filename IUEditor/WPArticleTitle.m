//
//  WPArticleTitle.m
//  IUEditor
//
//  Created by jd on 2014. 7. 15..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "WPArticleTitle.h"

@implementation WPArticleTitle
-(NSString*)code{
    return @"<?php the_title(); ?>";
}

- (NSString*)sampleHTML{
    return @"Article Title will be here";
}

- (BOOL)shouldCompileFontInfo{
    return YES;
}

@end
