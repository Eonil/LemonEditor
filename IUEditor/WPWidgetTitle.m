//
//  WPWidgetTitle.m
//  IUEditor
//
//  Created by jd on 8/18/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "WPWidgetTitle.h"

@implementation WPWidgetTitle

- (id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    [self setPositionType:IUPositionTypeRelative];
    
    [self.css eradicateTag:IUCSSTagPixelHeight];
    return self;
}

- (BOOL)canChangeCenter{
    return NO;
}

- (NSString*)cssClass{
    return [NSString stringWithFormat:@".%@ > .WPWidget > .WPWidgetTitle", self.parent.parent.htmlID];
}

-(NSString*)sampleHTML{
    return [NSString stringWithFormat:@"<h2 id='%@' class='%@'>This is Title</h2>", self.htmlID, self.cssClassStringForHTML];
}
@end
