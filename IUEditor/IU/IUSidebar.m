//
//  IUSidebar.m
//  IUEditor
//
//  Created by seungmi on 2014. 9. 17..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "IUSidebar.h"

@implementation IUSidebar

-(id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    if(self){
        [self.undoManager disableUndoRegistration];
        
        [self.css eradicateTag:IUCSSTagPixelWidth];
        [self.css eradicateTag:IUCSSTagBGColor];
        
        self.positionType = IUPositionTypeFloatLeft;
        self.overflowType = IUOverflowTypeVisible;
        
        [self.undoManager enableUndoRegistration];
    }
    return self;
}

-(BOOL)canRemoveIUByUserInput{
    return NO;
}

- (BOOL)canChangeOverflow{
    return NO;
}
- (BOOL)canChangePositionType{
    return NO;
}

- (BOOL)hasX{
    return NO;
}

- (BOOL)hasY{
    return NO;
}

- (BOOL)hasWidth{
    return YES;
}
- (BOOL)hasHeight{
    return NO;
}

- (BOOL)canChangeXByUserInput{
    return NO;
}

- (BOOL)canChangeYByUserInput{
    return NO;
}

- (BOOL)canChangeWidthByUserInput{
    return NO;
}

- (BOOL)canCopy{
    return NO;
}

@end
