//
//  IUPage+WP.m
//  IUEditor
//
//  Created by jd on 8/10/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUPage+WP.h"
#import "IUProject.h"
#import "IUSection.h"

#import "WPArticleList.h"
#import "WPPageLinks.h"

@implementation IUPage (WP)

-(void)WPInitializeAsHome{
    [self.undoManager disableUndoRegistration];
    [self.pageContent removeAllIU];
    
    IUSection *section = [[IUSection alloc] initWithProject:self.project options:nil];
    [section.css eradicateTag:IUCSSTagBGColor];
    [section.css eradicateTag:IUCSSTagPixelHeight];
    [self.pageContent addIU:section error:nil];

    WPArticleList *list = [[WPArticleList alloc] initWithProject:self.project options:nil];
    [section addIU:list error:nil];
    
    WPPageLinks *links = [[WPPageLinks alloc] initWithProject:self.project options:nil];
    [section addIU:links error:nil];
    
    [self.undoManager enableUndoRegistration];
    [self.project.identifierManager registerIUs:@[section, list, links]];
}

-(void)WPInitializeAs404{
    [self.undoManager disableUndoRegistration];

    [self.pageContent removeAllIU];
    IUBox *text404 = [[IUBox alloc] initWithProject:self.project options:nil];
    text404.htmlID = @"text404";
    text404.name = @"text404";
    text404.text = @"Sorry, but the page you are looking for has not been found.\nTry checking the URL for errors, then hit the refresh button.";
    [text404.css setValue:@"Raleway Dots" forTag:IUCSSTagFontName];
    [text404.css setValue:@(24) forTag:IUCSSTagFontSize];
    [text404.css setValue:@"1.3" forTag:IUCSSTagLineHeight];
    [text404.css setValue:@(100) forTag:IUCSSTagPixelY];
    [text404 setPositionType:IUPositionTypeAbsolute];
    [text404.css setValue:@(750) forTag:IUCSSTagPixelWidth];
    [text404.css setValue:@(75) forTag:IUCSSTagPixelHeight];
    [text404.css eradicateTag:IUCSSTagBGColor];
    
    text404.enableCenter = YES;
    
    [self.pageContent addIU:text404 error:nil];
    
    [self.undoManager enableUndoRegistration];
    [self.project.identifierManager registerIUs:@[text404]];
}

-(void)WPInitializeAsIndex{
    [self.undoManager disableUndoRegistration];
    [self removeAllIU];
    [self.undoManager enableUndoRegistration];
}

-(void)WPInitializeAsPage{
    [self.undoManager disableUndoRegistration];
    [self removeAllIU];
    [self.undoManager enableUndoRegistration];
}

-(void)WPInitializeAsCategory{
    [self.undoManager disableUndoRegistration];
    [self removeAllIU];
    [self.undoManager enableUndoRegistration];

}


@end
