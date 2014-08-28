//
//  JDClickBox.h
//  IUEditor
//
//  Created by seungmi on 2014. 8. 29..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol JDClickBoxProtocol <NSObject>
- (void)doubleClick:(NSEvent *)event;
@end

@interface JDClickBox : NSBox

@property IBOutlet id <JDClickBoxProtocol> delegate;

@end
