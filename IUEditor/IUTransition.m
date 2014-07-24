//
//  IUTransition.m
//  IUEditor
//
//  Created by jd on 4/22/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUTransition.h"
#import "IUItem.h"

@interface IUTransition()
@property IUItem *firstItem;
@property IUItem *secondItem;
@end


@implementation IUTransition{
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[self undoManager] disableUndoRegistration];
        
        [aDecoder decodeToObject:self withProperties:[IUTransition properties]];
        
        [[self undoManager] enableUndoRegistration];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFromObject:self withProperties:[IUTransition properties]];
}

- (id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    
    if(self){
        [[self undoManager] disableUndoRegistration];

        _firstItem = [[IUItem alloc] initWithProject:project options:options];
        _secondItem = [[IUItem alloc] initWithProject:project options:options];
        [_secondItem.css setValue:@(NO) forTag:IUCSSTagDisplay forWidth:IUCSSMaxViewPortWidth];
        
        [self addIU:_firstItem error:nil];
        [self addIU:_secondItem error:nil];
        self.currentEdit = 0;
        self.eventType = @"Click";
        self.animation = @"Blind";
        self.duration  = 0.2;
        
        [[self undoManager] enableUndoRegistration];

    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    IUTransition *iu = [super copyWithZone:zone];
    [[self undoManager] disableUndoRegistration];

    iu.currentEdit = _currentEdit;
    iu.eventType = [_eventType copy];
    iu.animation = [_animation copy];
    iu.duration = _duration;
    
    [[self undoManager] enableUndoRegistration];

    return iu;
}
- (void)connectWithEditor{
    [super connectWithEditor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectionChanged:) name:IUNotificationSelectionDidChange object:nil];

}

- (void)dealloc{
    if([self isConnectedWithEditor]){
        [[NSNotificationCenter defaultCenter] removeObserver:self name:IUNotificationSelectionDidChange object:nil];
    }
}

- (void)selectionChanged:(NSNotification*)noti{
    NSMutableSet *set = [NSMutableSet setWithArray:self.children];
    [set intersectSet:[NSSet setWithArray:[noti userInfo][@"selectedObjects"]]];
    if ([set count] != 1) {
        return;
    }
    IUBox *box = [set anyObject];
    if (box == _firstItem) {
        [self setCurrentEdit:0];
    }
    else {
        [self setCurrentEdit:1];
    }
}


- (void)setHtmlID:(NSString *)htmlID{
    [super setHtmlID:htmlID];
    _firstItem.htmlID = [htmlID stringByAppendingString:@"Item1"];
    _firstItem.name = _firstItem.htmlID;
    _secondItem.htmlID = [htmlID stringByAppendingString:@"Item2"];
    _secondItem.name = _secondItem.htmlID;
}

- (void)setCurrentEdit:(NSInteger)currentEdit{
    _currentEdit = currentEdit;
    if (currentEdit == 0) {
        [_firstItem.css setValue:@(YES) forTag:IUCSSTagDisplay forWidth:IUCSSMaxViewPortWidth];
        [_secondItem.css setValue:@(NO) forTag:IUCSSTagDisplay forWidth:IUCSSMaxViewPortWidth];
    }
    else {
        [_firstItem.css setValue:@(NO) forTag:IUCSSTagDisplay forWidth:IUCSSMaxViewPortWidth];
        [_secondItem.css setValue:@(YES) forTag:IUCSSTagDisplay forWidth:IUCSSMaxViewPortWidth];
    }
}

- (void)setEventType:(NSString *)eventType{
    if([_eventType isEqualToString:eventType]){
        return ;
    }
    
    [[self.undoManager prepareWithInvocationTarget:self] setEventType:_eventType];
    
    _eventType = eventType;
}

- (void)setAnimation:(NSString *)animation{
    if ([_animation isEqualToString:animation]) {
        return;
    }
    
    [[self.undoManager prepareWithInvocationTarget:self] setAnimation:_animation];
    _animation = animation;
}

- (void)setDuration:(float)duration{
    if(_duration == duration){
        return;
    }
    [[self.undoManager prepareWithInvocationTarget:self] setAnimationDuration:_duration];
    _duration = duration;
}

@end
