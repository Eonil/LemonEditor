//
//  WPMenu.m
//  IUEditor
//
//  Created by jw on 7/16/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "WPMenu.h"

@implementation WPMenu
- (NSString*)code{
    return @"<?php  wp_nav_menu( array(  'theme_location' => 'main_menu',  )); ?>";
}
- (NSString*)sampleText{
    return @"Menu will be here.";
}
@end
