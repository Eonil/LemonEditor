//
//  WPArticleList.m
//  IUEditor
//
//  Created by jd on 2014. 7. 16..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "WPArticleList.h"
#import "WPArticle.h"

/*
 code structure
 
 WP article list prefix code
       [wp article code]
 wp article list postfix code
 */

@implementation WPArticleList
- (id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    self.positionType = IUPositionTypeRelative;
    [self.css eradicateTag:IUCSSTagPixelHeight];
    
    [self.css setValue:[NSColor whiteColor] forTag:IUCSSTagBGColor];
    
    
    WPArticle *article = [[WPArticle alloc] initWithProject:project options:options];
    [self addIU:article error:nil];
    
    [self.css setValue:@(800) forTag:IUCSSTagPixelWidth forViewport:IUCSSDefaultViewPort];
    return self;
}

- (NSString*)prefixCode{
    return @"<? while ( have_posts() ) : the_post(); ?>";
}

- (NSString*)postfixCode{
    return @"<? endwhile ?>";
}
@end
