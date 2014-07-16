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
    return      @"<?php    global $wp_query;    $big = 999999999;    echo paginate_links( array( 'base' => str_replace( $big, '%#%', esc_url( get_pagenum_link( $big ) ) ), 'format' => '?paged=%#%', 'current' => max( 1, get_query_var('paged') ),                       'total' => $wp_query->max_num_pages, ) );  ?>";
}
- (NSString*)sampleText{
    return @"Page numbers will be here.";
}
@end
