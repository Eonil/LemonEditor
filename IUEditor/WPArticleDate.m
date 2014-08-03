//
//  WPArticleDate.m
//  IUEditor
//
//  Created by jd on 2014. 7. 16..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "WPArticleDate.h"
#import "WPArticle.h"

@implementation WPArticleDate

-(NSString*)code{
    return @"<?php echo get_the_date(); ?>";
}
- (NSString*)sampleHTML{
    return @"Publishing date will be here";
}
- (BOOL)shouldCompileFontInfo{
    return YES;
}


@end
