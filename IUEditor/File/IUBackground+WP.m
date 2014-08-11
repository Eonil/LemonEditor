//
//  IUBackground+WP.m
//  IUEditor
//
//  Created by jd on 8/10/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUBackground+WP.h"
#import "WPSiteTitle.h"
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
    [title.css setValue:@(17) forTag:IUCSSTagPixelX];
    [title.css setValue:@(15) forTag:IUCSSTagPixelY];

    
    WPSiteDescription *desc = [[WPSiteDescription alloc] initWithProject:self.project options:nil];
    desc.htmlID = @"SiteDescription";
    desc.name = @"SiteDescription";
    [desc.css eradicateTag:IUCSSTagBGColor];
    [desc.css setValue:[NSColor whiteColor] forTag:IUCSSTagFontColor];
    [desc.css setValue:@(IUAlignLeft) forTag:IUCSSTagTextAlign];
    [desc.css setValue:@(17) forTag:IUCSSTagPixelX];
    [desc.css setValue:@(62) forTag:IUCSSTagPixelY];

    [self.header addIU:title error:nil];
    [self.header addIU:desc error:nil];
    [self.project.identifierManager registerIUs:@[title, desc]];}

@end
