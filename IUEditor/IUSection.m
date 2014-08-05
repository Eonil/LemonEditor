//
//  IUResponsiveSection.m
//  IUEditor
//
//  Created by jd on 4/24/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUSection.h"

@implementation IUSection

- (id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    if(self){
        [self.css setValue:@(0) forTag:IUCSSTagXUnitIsPercent forWidth:IUCSSDefaultViewPort];
        [self.css setValue:@(0) forTag:IUCSSTagYUnitIsPercent forWidth:IUCSSDefaultViewPort];
        [self.css setValue:@(1) forTag:IUCSSTagWidthUnitIsPercent forWidth:IUCSSDefaultViewPort];
        [self.css setValue:@(0) forTag:IUCSSTagHeightUnitIsPercent forWidth:IUCSSDefaultViewPort];
        
        [self.css setValue:@(100) forTag:IUCSSTagPercentWidth forWidth:IUCSSDefaultViewPort];
        [self.css setValue:@(500) forTag:IUCSSTagPixelHeight forWidth:IUCSSDefaultViewPort];
        [self.css setValue:@(0) forTag:IUCSSTagPixelX forWidth:IUCSSDefaultViewPort];
        [self.css setValue:@(0) forTag:IUCSSTagPixelY forWidth:IUCSSDefaultViewPort];
        
        self.positionType = IUPositionTypeRelative;
     }
    return self;
}


-(id)initWithCoder:(NSCoder *)aDecoder{
    self =  [super initWithCoder:aDecoder];
    if(self){
        [aDecoder decodeToObject:self withProperties:[[IUSection class] properties]];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFromObject:self withProperties:[[IUSection class] properties]];
    
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

- (BOOL)canChangePositionType{
    return NO;
}

@end
