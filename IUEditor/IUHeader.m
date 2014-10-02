//
//  IUHeader.m
//  IUEditor
//
//  Created by JD on 3/31/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUHeader.h"

@implementation IUHeader

-(id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    if(self){
        [self.undoManager disableUndoRegistration];
        
        [self.css eradicateTag:IUCSSTagPixelWidth];
        [self.css eradicateTag:IUCSSTagBGColor];
        [self.css setValue:@(YES) forTag:IUCSSTagWidthUnitIsPercent forViewport:IUCSSDefaultViewPort];
        [self.css setValue:@(100) forTag:IUCSSTagPercentWidth forViewport:IUCSSDefaultViewPort];
        [self.css setValue:@(120) forTag:IUCSSTagPixelHeight forViewport:IUCSSDefaultViewPort];
        
        self.positionType = IUPositionTypeRelative;
        self.overflowType = IUOverflowTypeVisible;
        
        [self.undoManager enableUndoRegistration];
    }
    return self;
}

- (void)connectWithEditor{
    [super connectWithEditor];
}


#pragma mark - property

- (NSArray*)children{
    if (self.prototypeClass == nil) {
        //for version converting for document befor IU_VERSION_LAYOUT
        if(_m_children.count > 0){
            return _m_children;
        }
        
        return [NSArray array];
    }
    return @[self.prototypeClass];
}

#pragma mark - should

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

- (BOOL)canChangeXByUserInput{
    return NO;
}

- (BOOL)canChangeYByUserInput{
    return NO;
}

- (BOOL)canChangeWidthByUserInput{
    return NO;
}
- (BOOL)canChangeHeightByUserInput{
    return NO;
}
- (BOOL)canCopy{
    return NO;
}


@end
