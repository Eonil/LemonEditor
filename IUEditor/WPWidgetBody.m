//
//  WPWidgetBody.m
//  IUEditor
//
//  Created by jd on 8/18/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "WPWidgetBody.h"

@implementation WPWidgetBody

- (id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    [self setPositionType:IUPositionTypeRelative];
    [self.css eradicateTag:IUCSSTagPixelHeight];
    return self;
}

- (NSString*)cssClass{
    return [NSString stringWithFormat:@".%@ > .WPWidget > ul", self.parent.parent.htmlID];
}

- (NSString *)sampleHTML{
    return [NSString stringWithFormat:@"<ul id='%@' class='%@'><li class='cat-item cat-item-1'>First Line</li><li class='cat-item cat-item-2'>Second Line</li></ul>", self.htmlID, self.cssClassStringForHTML];
}

- (BOOL)canMoveToOtherParent{
    return NO;
}

- (BOOL)canRemoveIUByUserInput{
    return NO;
}
@end
