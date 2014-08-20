//
//  WPWidget.m
//  IUEditor
//
//  Created by jd on 8/16/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "WPWidget.h"

@implementation WPWidget

- (id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    if (self) {
        self.titleWidget = [[WPWidgetTitle alloc] initWithProject:project options:options];
        [self addIU:self.titleWidget error:nil];
        
        self.bodyWidget = [[WPWidgetBody alloc] initWithProject:project options:options];
        [self addIU:self.bodyWidget error:nil];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    [aDecoder decodeToObject:self withProperties:[WPWidget properties]];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFromObject:self withProperties:[WPWidget properties]];
}


- (BOOL)hasX{
    return NO;
}

- (BOOL)hasY{
    return NO;
}

- (BOOL)hasWidth{
    return NO;
}

- (BOOL)hasHeight{
    return NO;
}

- (NSString*)sampleHTML{
    NSString *ret =  [NSString stringWithFormat:@"<div id ='%@' class='%@'>%@%@</div>", self.htmlID, self.cssClassStringForHTML, self.titleWidget.sampleHTML, self.bodyWidget.sampleHTML];
    return ret;
}

@end
