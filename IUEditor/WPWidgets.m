//
//  WPWidgets.m
//  IUEditor
//
//  Created by jd on 8/14/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "WPWidgets.h"

@implementation WPWidgets

- (id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    _wordpressName = @"IUWidgets";
    return self;
}

- (void)setWordpressName:(NSString *)wordpressName{
    if ([wordpressName length] == 0) {
        _wordpressName = @"IUWidgets";
        return;
    }
    _wordpressName = wordpressName;
}

- (NSString*)code{
    return @"<?php dynamic_sidebar( 'wp_sidebar' ); ?>";
}

- (NSString*)sampleHTML{
    return @"<div>\
                <div>\
                    <h2 class='rounded'>까뗴고리</h2>\
                    <ul>\
                        <li class='cat-item cat-item-3'>Your Category</li>\
                        <li class='cat-item cat-item-1'>Uncategorized</li>\
                    </ul>\
                </div>\
                <div>\
                    <h2 class='rounded'>Archives</h2>\
                    <ul>\
                        <li>August 2014</li>\
                        <li>July 2014</li>\
                    </ul>\
                </div>\
            </div>";
}
@end
