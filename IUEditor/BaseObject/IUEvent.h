//
//  IUEvent.h
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 25..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    IUEventActionTypeClick,
    IUEventActionTypeHover,
    
}IUEventActionType;

typedef enum{
    IUEventVisibleTypeBlind,
    IUEventVisibleTypeSlide,
    IUEventVisibleTypeFold,
    IUEventVisibleTypeBounce,
    IUEventVisibleTypeClip,
    IUEventVisibleTypeDrop,
    IUEventVisibleTypeExplode,
    IUEventVisibleTypeHide,
    IUEventVisibleTypePuff,
    IUEventVisibleTypePulsate,
    IUEventVisibleTypeScale,
    IUEventVisibleTypeShake,
    IUEventVisibleTypeSize,
    IUEventVisibleTypeHighlight,
}IUEventVisibleType;

@interface IUEvent : NSObject <NSCopying>

//trigger
@property (nonatomic) NSString *variable;
@property (nonatomic) NSInteger maxValue, initialValue;
@property (nonatomic) IUEventActionType actionType;

//receiver
@property (nonatomic) BOOL  enableVisible;
@property NSString *eqVisibleVariable;
@property (nonatomic) NSString *eqVisible;
@property (nonatomic) NSInteger eqVisibleDuration;
@property (nonatomic) IUEventVisibleType directionType;

@property (nonatomic) BOOL enableFrame;
@property NSString *eqFrameVariable;
@property (nonatomic) NSString *eqFrame;
@property (nonatomic) NSInteger eqFrameDuration;
@property (nonatomic) CGFloat   eqFrameWidth, eqFrameHeight;

+ (NSArray *)visibleTypeArray;

@end
