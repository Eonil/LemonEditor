//
//  WPPageLink.m
//  IUEditor
//
//  Created by jw on 7/15/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "WPPageLinks.h"

@implementation WPPageLinks
- (NSString*)code{
    return @"<?php\n\
    global $wp_query;\n\
    $big = 999999999;\n\
    echo paginate_links( array(\n\
        'base' => str_replace( $big, '%%#%%', esc_url( get_pagenum_link( $big ) ) ),\n\
        'format' => '?paged=%%#%%',\n\
        'current' => max( 1, get_query_var('paged') ),\n\
        'total' => $wp_query->max_num_pages\n\
    ) );\n\
    ?>";
}
- (NSString*)sampleInnerHTML{
    return @"Page numbers will be here.";
}

- (BOOL)shouldCompileFontInfo{
    return YES;
}

@end
