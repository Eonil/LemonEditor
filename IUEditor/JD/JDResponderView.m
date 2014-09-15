//
//  JDResponderView.m
//  IUEditor
//
//  Created by seungmi on 2014. 9. 15..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "JDResponderView.h"

@implementation JDResponderView

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}
- (BOOL)acceptsFirstResponder{
    return YES;
}

- (void)setViewController:(NSViewController *)newController
{
    if (viewController)
    {
        NSResponder *controllerNextResponder = [viewController nextResponder];
        [super setNextResponder:controllerNextResponder];
        [viewController setNextResponder:nil];
    }
    
    viewController = newController;
    
    if (newController)
    {
        NSResponder *ownNextResponder = [self nextResponder];
        [super setNextResponder: viewController];
        [viewController setNextResponder:ownNextResponder];
    }
}

- (void)setNextResponder:(NSResponder *)newNextResponder
{
    if (viewController)
    {
        [viewController setNextResponder:newNextResponder];
        return;
    }
    
    [super setNextResponder:newNextResponder];
}

@end
