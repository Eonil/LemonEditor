//
//  JDResponderView.h
//  IUEditor
//
//  Created by seungmi on 2014. 9. 15..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//
// From : https://gist.github.com/panupan/1248654

#import <Cocoa/Cocoa.h>

// Allows a NSViewController to be automatically added to the responder chain
@interface JDResponderView : NSView{
    IBOutlet NSViewController *viewController;

}


@end
