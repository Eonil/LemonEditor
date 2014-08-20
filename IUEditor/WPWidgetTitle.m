//
//  WPWidgetTitle.m
//  IUEditor
//
//  Created by jd on 8/18/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "WPWidgetTitle.h"

@implementation WPWidgetTitle

- (BOOL)canChangeCenter{
    return NO;
}

-(NSString*)sampleHTML{
    return [NSString stringWithFormat:@"<h2 id='%@' class='%@'>This is Title</h2>", self.htmlID, self.cssClassStringForHTML];
}
@end
