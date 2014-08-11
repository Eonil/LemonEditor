//
//  IUBackground+WP.m
//  IUEditor
//
//  Created by jd on 8/10/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUBackground+WP.h"
#import "WPSiteTitle.h"
#import "WPMenu.h"
#import "WPSiteDescription.h"
#import "IUProject.h"

@implementation IUBackground (WP)

- (void)WPInitialize{
    for (IUBox *box in self.header.children) {
        [self.header removeIU:box];
    }
    WPSiteTitle *title = [[WPSiteTitle alloc] initWithProject:self.project options:nil];
    title.htmlID = @"SiteTitle";
    title.name = @"SiteTitle";
    [title.css eradicateTag:IUCSSTagBGColor];
    [title.css setValue:[NSColor whiteColor] forTag:IUCSSTagFontColor];
    [title.css setValue:@(IUAlignLeft) forTag:IUCSSTagTextAlign];
    [title.css setValue:@(16) forTag:IUCSSTagPixelX];
    [title.css setValue:@(15) forTag:IUCSSTagPixelY];
    [self.header addIU:title error:nil];
    [self.project.identifierManager registerIUs:@[title]];
    
    WPSiteDescription *desc = [[WPSiteDescription alloc] initWithProject:self.project options:nil];
    desc.htmlID = @"SiteDescription";
    desc.name = @"SiteDescription";
    [desc.css eradicateTag:IUCSSTagBGColor];
    [desc.css setValue:[NSColor whiteColor] forTag:IUCSSTagFontColor];
    [desc.css setValue:@(IUAlignLeft) forTag:IUCSSTagTextAlign];
    [desc.css setValue:@(16) forTag:IUCSSTagPixelX];
    [desc.css setValue:@(62) forTag:IUCSSTagPixelY];
    [self.header addIU:desc error:nil];
    [self.project.identifierManager registerIUs:@[desc]];

    WPMenu *menu = [[WPMenu alloc] initWithProject:self.project options:nil];
    menu.htmlID = @"Menu";
    menu.name = @"Menu";
    [menu.css setValue:@(YES)   forTag:IUCSSTagWidthUnitIsPercent];
    [menu.css setValue:@(100)   forTag:IUCSSTagPercentWidth];
    [menu.css setValue:@(105)   forTag:IUCSSTagPixelY];
    [menu.css setValue:@(40)    forTag:IUCSSTagPixelHeight];
    [menu.css setValue:[NSColor whiteColor] forTag:IUCSSTagFontColor];
    [menu.css setValue:nil      forTag:IUCSSTagBGColor];
    [self.header addIU:menu error:nil];
    [self.project.identifierManager registerIUs:@[menu]];
    
    [self.header.css setValue:@(144) forTag:IUCSSTagPixelHeight];
}

@end
