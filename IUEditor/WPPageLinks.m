//
//  WPPageLink.m
//  IUEditor
//
//  Created by jw on 7/15/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "WPPageLinks.h"
#import "WPPageLink.h"

@implementation WPPageLinks

- (id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    [self.undoManager disableUndoRegistration];
    
    self.positionType = IUPositionTypeRelative;
    self.enableCenter = YES;
    
    [self.css setValue:@(60) forTag:IUCSSTagPixelY];
    [self.css setValue:@(800) forTag:IUCSSTagPixelWidth];
    [self.css setValue:@(140) forTag:IUCSSTagPixelHeight];
    [self.css eradicateTag:IUCSSTagBGColor];
    
    [self.css setValue:@"Roboto" forTag:IUCSSTagFontName];
    [self.css setValue:@(12) forTag:IUCSSTagFontSize];
    [self.css setValue:@(1.0) forTag:IUCSSTagLineHeight];
    [self.css setValue:@(1.0) forTag:IUCSSTagTextLetterSpacing];
    [self.css setValue:@(IUAlignRight) forTag:IUCSSTagTextAlign];
    [self.css setValue:[NSColor rgbColorRed:0 green:120 blue:220 alpha:1] forTag:IUCSSTagFontColor];

    
    WPPageLink *pageLink = [[WPPageLink alloc] initWithProject:project options:options];
    [self addIU:pageLink error:nil];
    
    [self.undoManager enableUndoRegistration];
    return self;
}

- (NSString*)code{
    return @"<?php\n\
    global $wp_query;\n\
    $big = 999999999;\n\
    echo paginate_links( array(\n\
        'base' => str_replace( $big, '%%#%%', esc_url( get_pagenum_link( $big ) ) ),\n\
        'format' => '?paged=%%#%%',\n\
        'current' => max( 1, get_query_var('paged') ),\n\
        'total' => $wp_query->max_num_pages,\n\
        'type' => 'list',\n\
    ) );\n\
    ?>";
}
- (NSString*)sampleInnerHTML{
    return @"<ul class='page-numbers'>\
	<li><span class='page-numbers current'>1</span></li>\
	<li><a class='page-numbers' href='http://127.0.0.1/~jd/wordpress/?paged=2'>2</a></li>\
	<li><a class='page-numbers' href='http://127.0.0.1/~jd/wordpress/?paged=3'>3</a></li>\
	<li><a class='next page-numbers' href='http://127.0.0.1/~jd/wordpress/?paged=2'>Next &raquo;</a></li>\
    </ul>";
}

- (BOOL)shouldCompileFontInfo{
    return YES;
}

@end
