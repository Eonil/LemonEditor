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
        self.title = @"Sample Widget Title";
        self.lists = @"Lorem ipsum;Dolor sit amet;";
    }
    return self;
}

- (BOOL)hasX{
    return NO;
}

- (BOOL)hasWidth{
    return NO;
}

- (BOOL)hasHeight{
    return NO;
}

- (NSString*)sampleText{
    NSMutableString *ret =  [NSMutableString stringWithFormat:@"<div class='IU_WIDGET'>\
                <h2 class='IU_WIDGET_TITLE'>%@</h2>\
            <ul>", self.title];
    
    NSArray *list = [self.lists componentsSeparatedByString:@";"];
    for (NSString *listItem in list) {
        [ret appendFormat:@"<li class='cat-item cat-item-%ld'>%@</li>", [list indexOfObject:listItem], listItem];
    }
    [ret appendString:@"</ul></div>"];
    return [ret copy];
}

@end
