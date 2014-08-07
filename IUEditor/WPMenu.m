//
//  WPMenu.m
//  IUEditor
//
//

#import "WPMenu.h"

@implementation WPMenu

- (id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    self.fullWidthMenu = NO;
    self.leftRightPadding = 16;
    return self;
}

- (NSString*)sampleHTML{
    return @"<div class='menu-samplemenu-container'><ul id='menu-samplemenu'>\
        <li id='menu-item-01' class='menu-item'>My Blog</li>\
        <li id='menu-item-02' class='menu-item'>IUEditor</li>\
        <li id='menu-item-03' class='menu-item'>Sample Page</li>\
        <li id='menu-item-04' class='menu-item'>Another Page</li>\
        </ul></div>\
    ";
}


-(NSString*)code{
    return @"<? wp_nav_menu() ?>";
}
@end
