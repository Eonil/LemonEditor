//
//  IUPage+WP.m
//  IUEditor
//
//  Created by jd on 8/10/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUPage+WP.h"
#import "IUProject.h"

@implementation IUPage (WP)

-(void)WPInitializeAsHome{
    [self removeAllIU];
}

-(void)WPInitializeAs404{
    [self removeAllIU];
    IUBox *text404 = [[IUBox alloc] initWithProject:self.project options:nil];
    text404.htmlID = @"text404";
    text404.name = @"text404";
    text404.text = @"Sorry, but the page you are looking for has not been found.\nTry checking the URL for errors, then hit the refresh button.";
    [text404.css setValue:@"Raleway Dots" forKey:IUCSSTagFontName];
    [text404.css setValue:@(24) forKey:IUCSSTagFontSize];
    [text404.css setValue:@"1.3" forKey:IUCSSTagLineHeight];
    [text404.css setValue:@(100) forKey:IUCSSTagPixelY];
    [text404 setPositionType:IUPositionTypeAbsolute];
    text404.enableCenter = YES;
    
    [self.project.identifierManager registerIUs:@[text404]];
}

-(void)WPInitializeAsIndex{
    [self removeAllIU];
}

-(void)WPInitializeAsPage{
    [self removeAllIU];
}

-(void)WPInitializeAsCategory{
    [self removeAllIU];
}


@end
