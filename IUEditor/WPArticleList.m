//
//  WPArticleList.m
//  IUEditor
//
//  Created by jd on 2014. 7. 16..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "WPArticleList.h"
#import "WPArticle.h"

@implementation WPArticleList
- (id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    WPArticle *article = [[WPArticle alloc] initWithProject:project options:options];
    [self addIU:article error:nil];
    
    [self.css setValue:@(400) forTag:IUCSSTagWidth forWidth:IUCSSMaxViewPortWidth];
    [self.css setValue:@(600) forTag:IUCSSTagHeight forWidth:IUCSSMaxViewPortWidth];
    return self;
}

- (NSString*)code{
    NSMutableString *str = [NSMutableString stringWithString:@"<? while ( have_posts() ) : the_post(); ?>"];
    [str appendString:@"<? endwhile ?>"];
    
    return str;
}
@end
