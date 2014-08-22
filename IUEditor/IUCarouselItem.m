//
//  IUCarouselItem.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 28..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "IUCarouselItem.h"

@implementation IUCarouselItem

- (id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    if(self){
        self.positionType = IUPositionTypeFloatLeft;
    }
    return self;
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

- (BOOL)canChangePositionType{
    return NO;
}

- (BOOL)shouldAddIUByUserInput{
    return YES;
}
-(BOOL)canRemoveIUByUserInput{
    return NO;
}

- (BOOL)canSelectAtFirst{
    return NO;
}
@end
